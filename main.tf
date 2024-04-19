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

variable "google_maps_api_server_key" {
  description = "google maps api server key"
  type        = string
  default     = null
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

resource "aws_ssm_parameter" "google_maps_api_server_key" {
  count = var.google_maps_api_server_key != null ? 1 : 0
  name        = "/google_maps_api/${random_pet.google_maps_api.id}/server_key"
  description = "google maps api server key"
  type        = "SecureString"
  value       = var.google_maps_api_server_key
}

data "aws_region" "current" {}

output "GOOGLE_MAPS_API_KEY" {
  value = {
    arn : aws_ssm_parameter.google_maps_api_key.arn
    key : aws_ssm_parameter.google_maps_api_key.name
    region : data.aws_region.current.name
    type : "ssm"
  }
}

output "GOOGLE_MAPS_API_SERVER_KEY" {
  value = var.google_maps_api_server_key != null ? {
    arn : aws_ssm_parameter.google_maps_api_server_key[0].arn
    key : aws_ssm_parameter.google_maps_api_server_key[0].name
    region : data.aws_region.current.name
    type : "ssm"
  } : {
    arn : aws_ssm_parameter.google_maps_api_key.arn
    key : aws_ssm_parameter.google_maps_api_key.name
    region : data.aws_region.current.name
    type : "ssm"
  }
}

