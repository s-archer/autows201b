data "terraform_remote_state" "aws_demo" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform/terraform.tfstate"
  }
}

terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.6.0"
    }
  }
  required_version = ">= 0.13"
}

provider "bigip" {
  alias    = "f5-1"
  address  = data.terraform_remote_state.aws_demo.outputs.f5_ui
  username = data.terraform_remote_state.aws_demo.outputs.f5_username
  password = data.terraform_remote_state.aws_demo.outputs.f5_password
}

# For testing, write out to local file
resource "local_file" "rendered_as3" {
  content       = templatefile("../templates/tf_templated_as3.tpl", {
    virtual_ip    = var.as3vip
    tenant_name   = var.as3tenant
    app_name      = var.as3app
    app_list      = var.app_definition

  })
  filename = "${path.module}/rendered_as3.json"
}

# For testing, write out to file
resource "bigip_as3" "tf_templated_as3" {
  as3_json        = templatefile("../templates/tf_templated_as3.tpl", {
    virtual_ip    = var.as3vip
    tenant_name   = var.as3tenant
    app_name      = var.as3app
    app_list      = var.app_definition
  })
  provider        = bigip.f5-1
  tenant_filter   = var.as3tenant
}




