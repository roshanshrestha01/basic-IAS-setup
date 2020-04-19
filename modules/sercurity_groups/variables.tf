variable "vpc_id" {
    description = "Default vpc id"
}

variable "name" {
    description = "Default security group name"
    default = "bats"
}

variable "tags" {
    description = "Default tag"
    default = {
    }
}