#!/bin/bash
set -e

custom_colour() {
  sudo tee -a $BASHRC_FILE > /dev/null <<EOT

#Custom colour
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1='\[\e[01;36m\]\u\[\e[01;37m\]@\[\e[01;33m\]\H\[\e[01;37m\]:\[\e[01;32m\]\w\[\e[01;37m\] $(parse_git_branch)$\[\033[0;37m\] '
EOT

}

BASHRC_FILE="/home/$USER/.bashrc"
YUM_PACKAGE_NAME="python python-devl python-pip openssl-devel git"
DEB_PACKAGE_NAME="python2.7 python-dev python-pip libssl-dev git"

  if cat /etc/*release | grep ^NAME | grep CentOS; then
    echo "==============================================="
    echo "Installing packages $YUM_PACKAGE_NAME on CentOS"
    echo "==============================================="
    sudo yum update -y
    sudo yum install -y $YUM_PACKAGE_NAME
    custom_colour
  elif cat /etc/*release | grep ^NAME | grep Red; then
    echo "==============================================="
    echo "Installing packages $YUM_PACKAGE_NAME on RedHat"
    echo "==============================================="
    sudo yum update -y
    sudo yum install -y $YUM_PACKAGE_NAME
    custom_colour
  elif cat /etc/*release | grep ^NAME | grep Fedora; then
    echo "================================================"
    echo "Installing packages $YUM_PACKAGE_NAME on Fedorea"
    echo "================================================"
    sudo yum update -y
    sudo yum install -y $YUM_PACKAGE_NAME
    custom_colour
  elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Ubuntu"
    echo "==============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
  elif cat /etc/*release | grep ^NAME | grep Debian ; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Debian"
    echo "==============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
  elif cat /etc/*release | grep ^NAME | grep Mint ; then
    echo "============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Mint"
    echo "============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
  elif cat /etc/*release | grep ^NAME | grep Knoppix ; then
    echo "================================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Kanoppix"
    echo "================================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
  else
    echo "OS NOT DETECTED, couldn't install package $PACKAGE"
    exit 1;
  fi

exit 0