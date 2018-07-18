#!/bin/bash

###
# Script made by reddit/u/ben-btc & EnterTheBlockchain.com
# Designed for a fresh install of Ubuntu 16.04
# Modified from and special thanks to reddit/u/ymmv2 for creating the btcAutoNode script
# https://www.reddit.com/r/Bitcoin/comments/1se3zd/how_to_create_a_full_bitcoin_node_in_a_5_ubuntu/
# Florincoin.org
# Version 1.1
###

###
echo "########### The server will reboot when the script is complete"
echo "########### Installing Dependencies"
cd ~
apt-get -y update
apt-get -y install software-properties-common python-software-properties htop
sudo add-apt-repository -y ppa:luke-jr/db48
apt-get -y update
apt-get -y install git build-essential automake autoconf libboost-all-dev libssl-dev pkg-config
apt-get -y install libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libtool
apt-get -y install libcurl4-openssl-dev db4.8 libevent-dev


echo "########### Creating Swap"
dd if=/dev/zero of=/swapfile bs=1M count=2048 ; mkswap /swapfile ; swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
sudo chmod 0600 /swapfile

echo "########### Cloning Florincoin and Compiling"
mkdir -p ~/src && cd ~/src
git clone https://github.com/florincoin/florincoin.git
cd florincoin
./autogen.sh
./configure
make
make install

echo "########### Create florincoin User"
useradd -m florincoin

echo "########### Creating florincoin.conf"
cd ~florincoin
sudo -u florincoin mkdir .florincoin
config=".florincoin/florincoin.conf"
sudo -u florincoin touch $config
echo "port=7312" > $config
echo "server=1" >> $config
echo "daemon=1" >> $config
#echo "connections=80" >> $config #default is 125
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config
echo "generate=0" >> $config
echo "txindex=1" >> $config
echo "addnode=146.185.148.114" >> $config
echo "addnode=192.241.171.45" >> $config
echo "addnode=188.166.6.99" >> $config
echo "addnode=176.9.59.110" >> $config
echo "addnode=162.243.107.112" >> $config #nyc2
echo "addnode=128.199.116.119" >> $config #sgp
echo "addnode=207.154.239.148" >> $config #de
echo "addnode=192.241.201.19" >> $config #sf1

echo "########### Setting up IPTables"
iptables -A INPUT -p tcp --dport 7312 -j ACCEPT

#echo "########### Download & Install Blockchain Snapshot"
#cd ~
#wget https://hellobitcoin.org/flo/flochain.tar.gz
#tar -xzvf flochain.tar.gz
#cp -r Florincoin\ Blockchain/* ~florincoin/.florincoin/
#chown -R florincoin ~florincoin/.florincoin
#rm -rf Florincoin\ Blockchain/
#rm flochain.tar.gz

echo "########### Setting up autostart (cron)"
crontab -l > tempcron
echo "0 3 * * * reboot" >> tempcron  # reboot at 3am to keep things working okay
crontab tempcron
rm tempcron

# Start on boot
sed -i '2a\
sudo -u florincoin /usr/local/bin/florincoind -datadir=/home/florincoin/.florincoin' /etc/rc.local

echo "############ Add an alias for easy use"
echo "alias flo=\"sudo -u florincoin florincoin-cli -datadir=/home/florincoin/.florincoin\"" >> ~/.bashrc  # example use: flo getinfo

reboot
