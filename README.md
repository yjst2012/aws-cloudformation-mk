

## Install aws cli version 1 
guide: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html

## Configure your aws env
guide: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html


## Usage

### Environment
Must specify ENV (prod, dev) in any make command, ie., make ENV=dev build.
Assuming dev in all below make cmd.

### Build

```bash
# Compile Lambda functions

$ > make ENV=dev build
```

### Upload lambda

```bash
# Upload Lambda functions

$ > make ENV=dev lambda
```

### Package

```bash
# Package the script

$ > make ENV=dev package
```

### Deployment

```bash
# Deploy CloudFormation Stack

$ > make ENV=dev deploy
```

### Destroy

```bash
# Delete CloudFormation Stack

$ > make ENV=dev destroy
```

