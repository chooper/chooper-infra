#!/bin/bash

source .env

set -ex -o pipefail

test -n "$GOBUT_DATABASE_URL"

pushd packer
packer build \
    -var "gobut_database_url=$GOBUT_DATABASE_URL" \
    app-host.json
