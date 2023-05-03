#!/bin/bash
sleep 30
apt-get -y update
apt-get -y install awscli
apt-get -y install \
    ca-certificates \
    curl \
    gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#/usr/share/nginx/html   путь nginx в контейнере 
#/var/lib/docker/volumes/nginx-index/_data  путь к volune c index.html от контейнера nginx
docker run --name html80 -d -v nginx-index80:/usr/share/nginx/html -p 80:80 nginx
docker run --name html8080 -d -v nginx-index8080:/usr/share/nginx/html -p 8080:80 nginx
