#!/bin/bash
sudo apt-get update
sudo apt-get install nginx git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev bison libgdbm-dev libncurses5-dev -y
sudo systemctl start nginx

sudo useradd -m deploy
# Use another password
echo -e "STFs9LU1bRVcObZ\nSTFs9LU1bRVcObZ" | sudo passwd deploy
chsh --shell /bin/bash deploy
