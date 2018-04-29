#!/bin/sh


# install docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install  -y docker-ce

# create zabbix container
sudo docker run --name mysql-server -t \
     --restart=always \
     -e MYSQL_DATABASE="zabbix" \
     -e MYSQL_USER="zabbix" \
     -e MYSQL_PASSWORD="zabbix" \
     -e MYSQL_ROOT_PASSWORD="zabbix" \
     -d mysql:5.7

sudo docker run --restart=always --name zabbix-java-gateway -d zabbix/zabbix-java-gateway:latest

sudo docker run --name zabbix-server-mysql -t \
     --restart=always \
     -e DB_SERVER_HOST="mysql-server" \
     -e MYSQL_DATABASE="zabbix" \
     -e MYSQL_USER="zabbix" \
     -e MYSQL_PASSWORD="zabbix" \
     -e MYSQL_ROOT_PASSWORD="zabbix" \
     --link mysql-server:mysql \
     --link zabbix-java-gateway:zabbix-java-gateway \
     -p 10051:10051 \
     -d zabbix/zabbix-server-mysql:latest

sudo docker run --name zabbix-web-nginx-mysql -t \
     --restart=always \
     -e DB_SERVER_HOST="mysql-server" \
     -e MYSQL_DATABASE="zabbix" \
     -e MYSQL_USER="zabbix" \
     -e MYSQL_PASSWORD="zabbix" \
     -e MYSQL_ROOT_PASSWORD="zabbix" \
     -e ZBX_SERVER_HOST="zabbix-server" \
     -e PHP_TZ="Asia/Tokyo" \
     --link mysql-server:mysql \
     --link zabbix-server-mysql:zabbix-server \
     -p 80:80 \
     -d zabbix/zabbix-web-nginx-mysql:latest

# install zabbix agent
wget http://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+xenial_all.deb
sudo dpkg -i zabbix-release_3.4-1+xenial_all.deb
sudo apt update
sudo apt install -y zabbix-agent


# /etc/zabbix/zabbix_agentd.conf
# Server=127.0.0.1 -> Server=127.0.0.1, 172.17.0.0/16
sudo cp -pfr /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.org
sudo sed -i -e 's/Server=127.0.0.1/Server=127.0.0.1,172.17.0.0\/16/g' /etc/zabbix/zabbix_agentd.conf

sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent
