#!/bin/bash
## Bash scrip to install docker and docker compose

cat << EOF > /tmp/docker-compose.yml
version: '2'
services:
  mariadb:
    image: 'docker.io/bitnami/mariadb:10.3-debian-10'
    environment:
      - MARIADB_USER=bn_jasperreports
      - MARIADB_DATABASE=bitnami_jasperreports
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'mariadb_data:/bitnami'
  jasperreports:
    image: 'docker.io/bitnami/jasperreports:7-debian-10'
    environment:
      - MARIADB_HOST=mariadb
      - MARIADB_PORT_NUMBER=3306
      - JASPERREPORTS_DATABASE_USER=bn_jasperreports
      - JASPERREPORTS_DATABASE_NAME=bitnami_jasperreports
      - ALLOW_EMPTY_PASSWORD=yes
    ports:
      - '80:8080'
    volumes:
      - 'jasperreports_data:/bitnami'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  jasperreports_data:
    driver: local
EOF

apt update 
apt install curl
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg |  apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io


#Install docker-compose
echo "Installing docker-compose"
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Running docker-composer with JasperSoft
cd /tmp
docker-compose up -d