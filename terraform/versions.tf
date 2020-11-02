terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    bigip = {
      source = "terraform-providers/bigip"
    }
    http = {
      source = "hashicorp/http"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = ">= 0.13"
}
