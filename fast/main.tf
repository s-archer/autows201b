data "terraform_remote_state" "aws_demo" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform/terraform.tfstate"
  }
}

# terraform {
#   required_providers {
#     bigip = {
#       source = "F5Networks/bigip"
#       version = "1.10.0"
#     }
#   }
# }

# provider "bigip" {
#   address = data.terraform_remote_state.aws_demo.outputs.f5_mgmt_ip
#   username = data.terraform_remote_state.aws_demo.outputs.f5_username
#   password = data.terraform_remote_state.aws_demo.outputs.f5_password
# }


resource "null_resource" "fast_app" {
  provisioner "local-exec" {
    command = "curl -k -u ${data.terraform_remote_state.aws_demo.outputs.f5_username}:${data.terraform_remote_state.aws_demo.outputs.f5_password} -X POST -H 'Content-type: application/json' --data-binary \"@${path.module}/rendered_fast.json\" ${data.terraform_remote_state.aws_demo.outputs.f5_ui}/mgmt/shared/fast/applications"
  }
}

# For testing, write out to file

resource "local_file" "rendered_fast_template" {
  content              = templatefile("./fast.tpl", {
    tenant_name      = var.tenant_name
    application_name = var.application_name
    virtual_port     = var.virtual_port
    virtual_address  = var.virtual_address
    server_port      = var.server_port
    server_addresses = var.server_addresses

  })
  filename = "${path.module}/rendered_fast.json"
}

# resource "bigip_fast_application" "post_app" {
#   template         = "examples/simple_http"
#   fast_json        = file("${path.module}/fast.json")
# }