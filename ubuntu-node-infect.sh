#!/bin/bash

# assumptions for rackspace
# - created user "jason"
# adduser jason sudo
# su jason
# sudo chown -R jason:jason /usr/local/
# 

# CONFIG

INSTALL_DOTFILES=true
INSTALL_NODE=false
FIX_EC2_FSTAB=false

# END CONFIG


function update_apt {

    echo "Updating existing software"

    echo "> sudo apt-get update"
    sudo apt-get update

    echo "> sudo apt-get upgrade"
    sudo apt-get upgrade
}

function install_git {

    echo "Install git"
    echo "> sudo apt-get install git-core build-essential"
    sudo apt-get install git-core build-essential
}

function install_dotfiles {
    mkdir -p src
    echo "> cd src"
    cd src
    echo "> git clone git://github.com/jtwb/rc.git"
    git clone git://github.com/jtwb/rc.git
    echo "> cd rc"
    cd rc
    ./install.sh
    cd ~
    source .bashrc
}

function install_node {

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
}

function fix_ec2_fstab {

    # fix fstab for ec2 bug
    echo "> sudo perl -p -i -e \"s|^/dev/sda2|#/dev/sda2|g\" /etc/fstab"
    sudo perl -p -i -e "s|^/dev/sda2|#/dev/sda2|g" /etc/fstab
}




echo "Infecting Ubuntu host with node server build"

update_apt
install_git

if $INSTALL_DOTFILES ; then
    install_dotfiles
fi

if $INSTALL_NODE ; then
    install_node
fi

if $FIX_EC2_FSTAB ; then
    fix_ec2_fstab
fi

echo "Infect process complete.  Download and install application software next."
