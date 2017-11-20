#!/bin/bash

set -eux -o pipefail

sudo apt-add-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get -y update
sudo apt-get -y install golang
go version
