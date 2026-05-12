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

echo "Configurando Jenkins na porta 8085..."
mkdir -p /etc/systemd/system/jenkins.service.d

cat > /etc/systemd/system/jenkins.service.d/override.conf <<EOF
[Service]
Environment="JENKINS_PORT=8085"
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

echo "Reiniciando Jenkins..."
systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

echo "Instalação finalizada."