#!/bin/bash

set -eux -o pipefail

sudo useradd --system gobut
sudo mkdir -p /home/gobut/go
sudo chown -R gobut /home/gobut

pushd /home/gobut
sudo -u gobut bash -c "echo 'export GOPATH=/home/gobut/go' >> .bashrc"
sudo -u gobut bash -c "source .bashrc ; go get github.com/chooper/gobut"
sudo -u gobut bash -c "source .bashrc ; go install github.com/chooper/gobut"

cat > /tmp/gobut-init.conf <<EOF
description	"gobut"

# start after cloud-init
start on stopped cloud-final

setuid gobut
setgid gobut

respawn
respawn limit 10 5
umask 022
console log

env BOTNAME=urlcatcher
# TODO secrets make me sad :(
env DATABASE_URL=$GOBUT_DATABASE_URL
env IRC_ADDRESS=dev.pearachute.net:6667
env IRC_CHANNEL="#hello"
env POLL_USERNAMES=charleshooper,japherwocky,foxhop,penni-piper,zz__
env STEAMSTATUS_API=http://127.0.0.1:10000
exec /home/gobut/go/bin/gobut
EOF

sudo mv /tmp/gobut-init.conf /etc/init/gobut.conf
sudo chown 0600 /etc/init/gobut.conf
