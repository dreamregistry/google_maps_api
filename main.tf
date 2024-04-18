terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {}
provider "random" {}

variable "google_maps_api_key" {
  description = "google maps api key"
  type        = string
}

resource "random_pet" "google_maps_api" {
  length = 2
}

resource "aws_ssm_parameter" "google_maps_api_key" {
  name        = "/google_maps_api/${random_pet.google_maps_api.id}/key"
  description = "google maps api key"
  type        = "SecureString"
  value       = var.google_maps_api_key
}

data "aws_region" "current" {}

output "GOOGLE_MAPS_API_KEY" {
  value = {
    arn: aws_ssm_parameter.google_maps_api_key.arn
    key: aws_ssm_parameter.google_maps_api_key.name
    region: data.aws_region.current.name
    type: "ssm"
  }
}

