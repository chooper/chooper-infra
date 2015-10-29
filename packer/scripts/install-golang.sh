#!/bin/bash

set -eux -o pipefail

sudo apt-add-repository -y ppa:evarlast/golang1.5
sudo apt-get -y update
# HACK(charles) Broken golang package
sudo apt-get -y install golang-go || true
sudo apt-get -y install golang-go
go version
