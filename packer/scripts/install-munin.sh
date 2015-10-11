#!/bin/bash

set -eux -o pipefail

sudo apt-get -y install munin-node munin-plugins-core munin-plugins-extra libnet-cidr-perl
sudo bash -c 'echo "cidr_allow 162.243.134.207/32" >> /etc/munin/munin-node.conf'
sudo service munin-node restart
