#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <ami-id>"
    exit 1
else
    ami="$1"
fi

set -eux -o pipefail

instance_type="t2.micro"
subnet="subnet-b737c2c0"
keypair="chooper_2015"
sg="sg-cab630af"
#userdata="$(base64 --input="userdata/init.sh")"
userdata="file://./userdata/init.sh"

aws ec2 run-instances --image-id "$ami" \
    --instance-type "$instance_type"    \
    --key-name "$keypair"               \
    --user-data "$userdata"             \
    --network-interfaces "[ { \"DeviceIndex\": 0, \"Groups\": [\"$sg\"], \"SubnetId\": \"$subnet\", \"DeleteOnTermination\": true, \"AssociatePublicIpAddress\": true } ]"
