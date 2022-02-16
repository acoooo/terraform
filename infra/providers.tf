terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.primary_region
}

provider "aws" {
  alias  = "central-eu"
  region = var.secondary_region
}