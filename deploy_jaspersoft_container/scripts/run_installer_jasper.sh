#!/bin/bash
## Bash scrip to install docker and docker compose

cat << EOF > /tmp/docker-compose-jasper.yml
version: '3.8'

services:
  jasperserver:
    image: agois/jasperserver-ce:7.8.0
    ports:
      - "8080:8080"
      - "8443:8443"
    depends_on:
      - jasperserver-init      
    env_file: jasper.env
    volumes:
      - jasper_webapp:/usr/local/tomcat/webapps/jasperserver
      - jasper_home:/usr/local/share/jasperserver
      - jasper_license:/usr/local/share/jasperserver/license 
      - jasper_keystore:/usr/local/share/jasperserver/keystore
      - jasper_customization:/usr/local/share/jasperserver/customization
    networks:
      - reportsnet
    command: ["/entrypoint-ce.sh", "run"]

  jasperserver-init:
    image: agois/jasperserver-ce-init:7.8.0
    deploy:
      restart_policy:
        condition: none
    env_file: jasper.env
    volumes:
      - jasper_init_home:/usr/local/share/jasperserver
      - jasper_keystore:/usr/local/share/jasperserver/keystore
    environment:
      - JRS_DBCONFIG_REGEN=true
    command: ["/wait-for-it.sh", "postgres:5432", "-t" , "30", "--", "/entrypoint-cmdline-ce.sh", "init"]
    networks:
      - reportsnet
networks:
  reportsnet:

volumes:
  jasper_home:
  jasper_webapp:
  jasper_license:
  jasper_keystore:
  jasper_customization:
  jasper_init_home:
EOF
cat << EOF > /tmp/jasper.env
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
docker-compose -f docker-compose-jasper.yml up -d