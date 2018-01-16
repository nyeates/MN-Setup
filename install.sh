#!/bin/bash

sudo touch /var/swap.img

sudo chmod 600 /var/swap.img

sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000

mkswap /var/swap.img

sudo swapon /var/swap.img

sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab

sudo apt-get update -y

sudo apt-get upgrade -y

sudo apt-get dist-upgrade -y

sudo apt-get install nano htop git -y

sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common -y

sudo apt-get install libboost-all-dev -y

sudo add-apt-repository ppa:bitcoin/bitcoin -y

sudo apt-get update -y

sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

wget https://github.com/qbic-platform/qbic/releases/download/v1.1/qbicd.tar.gz 

chmod -R 755 /root/qbicd.tar.gz

tar xvzf /root/qbicd.tar.gz

mkdir /root/qbic

mkdir /root/.qbiccore

cp /root/qbicd /root/qbic

cp /root/qbic-cli /root/qbic

chmod -R 755 /root/qbic

chmod -R 755 /root/.qbiccore

sudo apt-get install -y pwgen

GEN_PASS=`pwgen -1 20 -n`

echo -e "rpcuser=qbicrpc\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=256" > /root/.qbiccore/qbic.conf

cd /root/qbic

./qbicd -daemon

sleep 10

masternodekey=$(./qbic-cli masternode genkey)

./qbic-cli stop

echo -e "masternode=1\nmasternodeprivkey=$masternodekey" >> /root/.qbiccore/qbic.conf

./qbicd -daemon

cd /root/.qbiccore

sudo apt-get install -y git python-virtualenv

sudo git clone https://github.com/qbic-platform/sentinel.git

cd sentinel

export LC_ALL=C

sudo apt-get install -y virtualenv

virtualenv venv

venv/bin/pip install -r requirements.txt

echo "qbic_conf=/root/.qbiccore/qbic.conf" >> /root/. qbiccore/sentinel/sentinel.conf

crontab -l > tempcron

echo "* * * * * cd /root/. qbiccore/sentinel && ./venv/bin/python bin/sentinel.py 2>&1 >> sentinel-cron.log" >> tempcron

crontab tempcron

rm tempcron

echo "Masternode private key: $masternodekey"

echo "Welcome to the QBIC world"