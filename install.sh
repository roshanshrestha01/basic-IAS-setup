#!/bin/bash
sudo apt-get update
sudo apt-get install nginx git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev bison libgdbm-dev libncurses5-dev -y

git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

rbenv install -v 2.3.1
rbenv global 2.3.1
echo “gem: --no-document” > ~/.gemrc # Disable rubygems to generate local documentation for each gem that you install

#gem install rails
#rbenv rehash

sudo useradd -m deploy
# Use another password
echo -e "STFs9LU1bRVcObZ\nSTFs9LU1bRVcObZ" | sudo passwd deploy
chsh --shell /bin/bash deploy
