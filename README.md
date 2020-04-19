# Terraform build up

Project utilizes [registry](https://registry.terraform.io/) modules to build infrastructure

Register project modules

* [AWS VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc)

## Setting up terraform

* Download terraform from [here](https://www.terraform.io/downloads.html).
* Unzip downloaded file
* Move unzip file `sudo mv terraform /usr/local/bin/`


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

