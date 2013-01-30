#!/bin/bash

# assumptions for rackspace
# - created user "jason"
# adduser jason
# su jason
# sudo chown -R jason:jason /usr/local/
# 
echo "Infecting Ubuntu host with node server build"

echo "Updating existing software"

echo "> sudo apt-get update"
sudo apt-get update

echo "> sudo apt-get upgrade"
sudo apt-get upgrade

echo "Install git"
echo "> sudo apt-get install git-core build-essential"
sudo apt-get install git-core build-essential

NODE_TAG="v0.8.18"
echo "Install node.js $NODE_TAG"
echo "> sudo apt-get install libssl-dev"
sudo apt-get install libssl-dev
mkdir build
echo "> cd build"
cd build
echo "> git clone git://github.com/joyent/node.git"
git clone git://github.com/joyent/node.git
echo "> cd node"
cd node
echo "> git checkout $NODE_TAG"
git checkout $NODE_TAG
echo "> ./configure && make && sudo make install"
./configure && make && make install

# fix fstab for ec2 bug
# echo "> sudo perl -p -i -e \"s|^/dev/sda2|#/dev/sda2|g\" /etc/fstab"
# sudo perl -p -i -e "s|^/dev/sda2|#/dev/sda2|g" /etc/fstab

echo "Infect process complete.  Download and install application software next."
