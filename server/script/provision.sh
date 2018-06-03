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

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

cd /vagrant/
sudo docker-compose up -d 

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
