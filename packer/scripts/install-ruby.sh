#!/bin/bash

set -eux -o pipefail

sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get -y update
sudo apt-get -y install ruby2.2 ruby2.2-dev
ruby -v

sudo gem install bundler
bundler -v
