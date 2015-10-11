#!/bin/bash

set -eux -o pipefail

sudo apt-get -y install nginx
sudo service nginx status
