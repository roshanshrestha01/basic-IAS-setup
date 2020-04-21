# Terraform build up

Project utilizes [registry](https://registry.terraform.io/) modules to build infrastructure

Register project modules

* [AWS VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc)
* [AWS RDS AURORA](https://github.com/terraform-aws-modules/terraform-aws-rds-aurora)
* [AWS EC2](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance)


## Setting up terraform

* Download terraform from [here](https://www.terraform.io/downloads.html).
* Unzip downloaded file
* Move unzip file `sudo mv terraform /usr/local/bin/`

## Service to setup from AWS dashboard

* Create a `IAM` role to be used service created from terraform
* Create a `Key Pair` to be used


## Setting aws credentials

```sh
$ export AWS_ACCESS_KEY_ID="<ACCESS_KEY_ID>"
$ export AWS_SECRET_ACCESS_KEY="<SECRET_ACCESS_KEY>"
$ export AWS_DEFAULT_REGION="<DEFAULT_REGION>"
```

## Terrafrom build

```sh
$ terraform init
$ terraform plan
$ terraform apply
```


## SSH hardening

* Change default ports also security group ports
* Enable Verbose Logging `LogLevel VERBOSE`
* Disable root access `PermitRootLogin no`
* Disconnet Idle session `ClientAliveInterval 300  ClientAliveCountMax 0`
* Disable Password Authentication `PasswordAuthentication no`
