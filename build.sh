#!/bin/bash
#This is required to build the stuff

PKSLIST=/tmp/rpackages.txt
RMAJOR=3
RVERSION=3.2.2

NLOPT=nlopt-2.4.2

#Add here what kind of dependencies you need in general
#Check for packages here: https://pkgs.alpinelinux.org/packages
apt update && apt upgrade -y && apt install -y bash wget curl gcc git ca-certificates r-base=3.2.3-4 libssl-dev libcurl4-openssl-dev libxml2-dev openjdk-8-jre

# Download nlopt, as this will be needed by some r packages
mkdir /build
cd /build
wget https://github.com/stevengj/nlopt/releases/download/$NLOPT/$NLOPT.tar.gz
tar -xzf $NLOPT.tar.gz
cd $NLOPT
./configure
make
make install

# Download and install R packages from list
cat $PKSLIST | xargs -i sh -c 'R --vanilla <<EOF
source("https://bioconductor.org/biocLite.R")
biocLite("{}", ask=FALSE)
q()
EOF'


#Create mountpoints that we need
mkdir -p /sfs/7/qbic

#Clean up
rm -rf /var/cache/apk/*

cd /
rm -rf /build
