#!/bin/bash

set -eux -o pipefail

# update steamstatus api
pushd /home/steamstatus
sudo -u steamstatus bash -c "source .bashrc ; go get github.com/chooper/steamstatus-api"
sudo -u steamstatus bash -c "source .bashrc ; go install github.com/chooper/steamstatus-api"

# update gobut
pushd /home/gobut
sudo -u gobut bash -c "source .bashrc ; go get github.com/chooper/gobut"
sudo -u gobut bash -c "source .bashrc ; go install github.com/chooper/gobut"
