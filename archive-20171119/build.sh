#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <role>"
    exit 1
else
    role="$1"
fi

source .env

set -eux -o pipefail

test -n "$GOBUT_DATABASE_URL"

pushd packer
packer build \
    -var "gobut_database_url=$GOBUT_DATABASE_URL" \
    ${role}-host.json
