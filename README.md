# chooper-infra

Scripts and recipes to build my play things

## Usage

### Set-up

1. Install packer and ensure it's in `$PATH`

1. Install the AWS CLI and configure your credentials

1. Create a `.env` file containing the database URL for gobut

### Building an AMI

```bash
$ ./build.sh
```

This will call `packer` which will build an AMI and print its ID as it exits.

### Launch an instance

```bash
$ ./launch-ami.sh <ami-id>
```

This will launch a t2.micro in us-west-2 from the given AMI. The AWS CLI tools
will print the instance id before they exit.

### Promoting an instance to "prod"

```bash
$ ./promote-instance.sh <instance-id>
```

This will use the AWS CLI tools to remap a hardcoded Elastic IP to the given
instance id.
