#!/bin/bash

apt-get -y update

apt-get -y install awscli
apt-get -y install zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
apt-get -y install ruby

cd /home/ubuntu

aws s3 cp s3://aws-codedeploy-eu-west-1/latest/install . --region eu-west-1
chmod +x ./install
./install auto

# service codedeploy-agent status
# service codedeploy-agent start

gem install bundler
