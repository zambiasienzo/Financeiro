#!/bin/bash
set -euo pipefail

JENKINS_USER="${JENKINS_ADMIN_USER:?Variavel JENKINS_ADMIN_USER nao definida}"
JENKINS_PASS="${JENKINS_ADMIN_PASSWORD:?Variavel JENKINS_ADMIN_PASSWORD nao definida}"

JENKINS_HOME="/var/lib/jenkins"
JENKINS_PORT="8085"
JENKINS_URL="http://177.44.248.57:${JENKINS_PORT}/"

echo ">>> [1/10] Atualizando pacotes e instalando dependências..."
export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get install -y -qq \
  git curl wget gnupg ufw ca-certificates \
  maven openjdk-21-jdk \
  docker.io docker-compose

echo ">>> [2/10] Ativando Docker..."
systemctl enable docker
systemctl start docker

echo ">>> [3/10] Instalando Jenkins..."

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
  -o /usr/share/keyrings/jenkins-keyring.asc || \
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  -o /usr/share/keyrings/jenkins-keyring.asc

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -qq
apt-get install -y -qq jenkins

echo ">>> [4/10] Configurando Jenkins na porta ${JENKINS_PORT}..."

systemctl stop jenkins 2>/dev/null || true

mkdir -p /etc/systemd/system/jenkins.service.d

cat > /etc/systemd/system/jenkins.service.d/override.conf <<EOF
[Service]
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Dhudson.security.csrf.GlobalCrumbIssuerConfiguration.DISABLE_CSRF_PROTECTION=true"
ExecStart=
ExecStart=/usr/bin/jenkins --httpPort=${JENKINS_PORT}
EOF

echo ">>> [5/10] Criando usuário admin e configurando URL..."

usermod -aG docker jenkins

mkdir -p "${JENKINS_HOME}/init.groovy.d"

cat > "${JENKINS_HOME}/init.groovy.d/00-basic-security.groovy" <<EOF
import jenkins.model.*
import hudson.security.*
import jenkins.model.JenkinsLocationConfiguration

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("${JENKINS_USER}", "${JENKINS_PASS}")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

def location = JenkinsLocationConfiguration.get()
location.setUrl("${JENKINS_URL}")
location.save()

instance.save()
EOF

chown -R jenkins:jenkins "${JENKINS_HOME}"

echo ">>> [6/10] Liberando portas..."

ufw allow 22/tcp || true
ufw allow "${JENKINS_PORT}/tcp" || true
ufw allow 8081/tcp || true
ufw allow 8082/tcp || true
ufw allow 5433/tcp || true
ufw allow 5434/tcp || true
# ufw --force enable

echo ">>> [7/10] Iniciando Jenkins pela primeira vez..."

systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

echo "Aguardando Jenkins responder..."
for i in {1..40}; do
  if curl -sf "http://localhost:${JENKINS_PORT}/login" > /dev/null; then
    echo "Jenkins respondeu."
    break
  fi

  echo "Aguardando... ${i}"
  sleep 5
done

echo "Aguardando execução dos scripts Groovy..."
sleep 30

echo ">>> [8/10] Instalando plugins via API HTTP..."

cat > /tmp/plugins.xml <<EOF
<jenkins>
  <install plugin="workflow-aggregator@latest" />
  <install plugin="git@latest" />
  <install plugin="pipeline-stage-view@latest" />
</jenkins>
EOF

curl -s -X POST \
  "http://localhost:${JENKINS_PORT}/pluginManager/installNecessaryPlugins" \
  -u "${JENKINS_USER}:${JENKINS_PASS}" \
  -H "Content-Type: text/xml" \
  --data-binary @/tmp/plugins.xml

echo "Aguardando download e instalação dos plugins..."
sleep 120

echo "Reiniciando Jenkins para carregar plugins..."
systemctl restart jenkins

echo "Aguardando Jenkins voltar..."
for i in {1..40}; do
  if curl -sf "http://localhost:${JENKINS_PORT}/login" > /dev/null; then
    echo "Jenkins voltou."
    break
  fi

  echo "Aguardando... ${i}"
  sleep 5
done

echo ">>> [9/10] Criando jobs..."

cat > /tmp/job_homolog.xml <<'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition>
  <description>Pipeline de homologação do sistema financeiro</description>
  <keepDependencies>false</keepDependencies>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition">
    <scm class="hudson.plugins.git.GitSCM">
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/zambiasienzo/Financeiro.git</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
    </scm>
    <scriptPath>Jenkinsfile.homolog</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF

cat > /tmp/job_prod.xml <<'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition>
  <description>Pipeline de produção do sistema financeiro</description>
  <keepDependencies>false</keepDependencies>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition">
    <scm class="hudson.plugins.git.GitSCM">
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/zambiasienzo/Financeiro.git</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
    </scm>
    <scriptPath>Jenkinsfile.prod</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF

echo "Removendo jobs antigos, se existirem..."
rm -rf "${JENKINS_HOME}/jobs/financeiro-homolog"
rm -rf "${JENKINS_HOME}/jobs/financeiro-prod"

echo "Criando job financeiro-homolog..."
curl -s -X POST \
  "http://localhost:${JENKINS_PORT}/createItem?name=financeiro-homolog" \
  -u "${JENKINS_USER}:${JENKINS_PASS}" \
  -H "Content-Type: application/xml" \
  --data-binary @/tmp/job_homolog.xml

echo "Criando job financeiro-prod..."
curl -s -X POST \
  "http://localhost:${JENKINS_PORT}/createItem?name=financeiro-prod" \
  -u "${JENKINS_USER}:${JENKINS_PASS}" \
  -H "Content-Type: application/xml" \
  --data-binary @/tmp/job_prod.xml

echo ">>> [10/10] Reiniciando Jenkins e finalizando..."

chown -R jenkins:jenkins "${JENKINS_HOME}"

systemctl restart jenkins

sleep 30

echo ""
echo "======================================================"
echo "Jenkins configurado com sucesso."
echo "URL: ${JENKINS_URL}"
echo "Usuário: ${JENKINS_USER}"
echo "Jobs esperados:"
echo "- financeiro-homolog"
echo "- financeiro-prod"
echo "======================================================"