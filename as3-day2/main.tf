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
      version = "1.10.0"
    }
  }
}

provider "bigip" {
  address = data.terraform_remote_state.aws_demo.outputs.f5_mgmt_ip
  username = data.terraform_remote_state.aws_demo.outputs.f5_username
  password = data.terraform_remote_state.aws_demo.outputs.f5_password
}

resource "bigip_as3"  "as3-demo_tenant" {
       as3_json = templatefile("${path.module}/as3.tpl", {
        app_list = var.app_list
        waf_enable   = false
      })
       tenant_filter = "demo_tenant"
 }

 # For testing, write out to file

resource "local_file" "rendered_as3" {
  content = templatefile("${path.module}/as3.tpl", {
    #vip = local.pub_vs_eips_list[0].private_ip
    app_list = var.app_list
    waf_enable   = false
  })
  filename = "${path.module}/rendered_as3.json"
}