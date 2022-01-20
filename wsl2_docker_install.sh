#!/bin/sh

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

#도커 apt 소스 리스트 등록 우분투
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# 도커 설치
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# docker compose 설치
# v2.2.3
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 그룹 등록
sudo usermod -aG docker $USER
# 그룹 등록 후 터미널 껐다 켜야 적용됨. (docker.sock permission denied 관련 이슈)



sudo mkdir -p /etc/docker/
sudo tee /etc/docker/daemon.json > /dev/null <<EOT
{"insecure-registries" : ["10.10.10.7:5443:,"nas:5443","nas.supercreative.kr:5443"]}
EOT

#wsl 2인경우
sudo tee /etc/wsl.conf > /dev/null <<EOT
#[network]
#generateResolvConf = false
[boot]
command = service docker start
EOT

sudo service docker start