#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <instance-id>"
    exit 1
else
    instance="$1"
fi

set -eux -o pipefail

ip="52.24.46.52"

aws ec2 associate-address --instance-id "$instance" --public-ip "$ip"
