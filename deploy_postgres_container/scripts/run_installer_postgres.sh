#!/bin/bash
## Bash scrip to install docker and docker compose

cat << EOF > /tmp/docker-compose-postgres.yml
version: '3.8'

services:

  postgres:    
    image: postgres:9.5.22
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - reportsnet
    env_file: jasper_postgres.env

networks:
  reportsnet:

volumes:
  pgdata:
EOF

cat << EOF > /tmp/jasper_postgres.env

DB_HOST=postgres
DB_USER=postgres
DB_PASSWORD=postgres
DB_PORT=5432
DB_NAME=jasperserver
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
EOF

docker -v
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Installing docker..."
apt update 
apt install curl -y
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg |  apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y


#Install docker-compose
echo "Installing docker-compose"
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
fi
# Running docker-composer with JasperSoft
cd /tmp
echo "Starting postrgres docker"
docker-compose -f docker-compose-postgres.yml up -d