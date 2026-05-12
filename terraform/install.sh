#!/bin/bash
set -e

echo "Atualizando pacotes..."
apt update

echo "Instalando dependências básicas..."
apt install -y git curl gnupg ufw maven openjdk-21-jdk docker.io docker-compose

echo "Ativando Docker..."
systemctl enable docker
systemctl start docker

echo "Instalando Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update
apt install -y jenkins

echo "Configurando Jenkins na porta 8085 e sem tela inicial..."
mkdir -p /etc/systemd/system/jenkins.service.d

cat > /etc/systemd/system/jenkins.service.d/override.conf <<EOF
[Service]
Environment="JENKINS_PORT=8085"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"
EOF

echo "Liberando Jenkins para usar Docker..."
usermod -aG docker jenkins

echo "Liberando portas no firewall..."
ufw allow 22/tcp
ufw allow 8085/tcp
ufw allow 8081/tcp
ufw allow 8082/tcp
ufw allow 5433/tcp
ufw allow 5434/tcp
ufw --force enable

echo "Preparando Jenkins..."
mkdir -p /var/lib/jenkins/init.groovy.d
mkdir -p /var/lib/jenkins/jobs/financeiro-homolog
mkdir -p /var/lib/jenkins/jobs/financeiro-prod

cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy <<EOF
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(System.getenv("JENKINS_ADMIN_USER"), System.getenv("JENKINS_ADMIN_PASSWORD"))
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.save()
EOF

echo "Instalando plugins do Jenkins..."
jenkins-plugin-cli --plugins git workflow-aggregator pipeline-stage-view || true

echo "Criando job financeiro-homolog..."
cat > /var/lib/jenkins/jobs/financeiro-homolog/config.xml <<EOF
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job">
  <description>Pipeline de homologação do sistema financeiro</description>
  <keepDependencies>false</keepDependencies>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps">
    <scm class="hudson.plugins.git.GitSCM" plugin="git">
      <configVersion>2</configVersion>
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
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="empty-list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile.homolog</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF

echo "Criando job financeiro-prod..."
cat > /var/lib/jenkins/jobs/financeiro-prod/config.xml <<EOF
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job">
  <description>Pipeline de produção do sistema financeiro</description>
  <keepDependencies>false</keepDependencies>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps">
    <scm class="hudson.plugins.git.GitSCM" plugin="git">
      <configVersion>2</configVersion>
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
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="empty-list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile.prod</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF

echo "Ajustando permissões do Jenkins..."
chown -R jenkins:jenkins /var/lib/jenkins

echo "Reiniciando Jenkins..."
systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

echo "Instalação finalizada."