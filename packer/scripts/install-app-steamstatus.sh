#!/bin/bash

set -eux -o pipefail

sudo useradd --system steamstatus
sudo mkdir -p /home/steamstatus/go
sudo chown -R steamstatus /home/steamstatus

pushd /home/steamstatus
sudo -u steamstatus bash -c "echo 'export GOPATH=/home/steamstatus/go' >> .bashrc"
sudo -u steamstatus bash -c "source .bashrc ; go get github.com/chooper/steamstatus-api"
sudo -u steamstatus bash -c "source .bashrc ; go install github.com/chooper/steamstatus-api"

cat > /tmp/steamstatus-init.conf <<EOF
description	"steamstatus"

start on runlevel [2345]
stop on runlevel [!2345]

setuid steamstatus
setgid steamstatus

respawn
respawn limit 10 5
umask 022
console log

env PORT=10000
# TODO do something with logs
exec /home/steamstatus/go/bin/steamstatus-api web
EOF

sudo mv /tmp/steamstatus-init.conf /etc/init/steamstatus.conf
sudo chmod 0600 /etc/init/steamstatus.conf
