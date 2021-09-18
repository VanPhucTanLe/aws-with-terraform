terraform {
  backend "remote" {
    organization = "tanle-test"
    workspaces {
      name = "MyWorkspace-OwnerTanLe"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-1"
}
