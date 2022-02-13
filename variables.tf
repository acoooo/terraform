variable "policy_arn" {
  description = "List of policies we need to attach to a user"
  type        = list(any)
}

variable "primary_vpc_cidr" {
  type = string
}

variable "secondary_vpc_cidr" {
  type = string
}

variable "primary_vpc_public_subnet_cidr" {
  description = "list of subnet cidr"
  type        = list(any)
}

variable "primary_vpc_private_subnet_cidr" {
  description = "list of subnet cidr"
  type        = list(any)
}

variable "primary_vpc_database_subnet_cidr" {
  description = "list of subnet cidr"
  type        = list(any)
}

variable "secondary_vpc_public_subnet_cidr" {
  description = "list of subnet cidr"
  type        = list(any)
}

variable "secondary_vpc_private_subnet_cidr" {
  description = "list of subnet cidr"
  type        = list(any)
}

variable "secondary_vpc_database_subnet_cidr" {
  description = "list of subnet cidr"
  type        = list(any)
}