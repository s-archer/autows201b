
data "terraform_remote_state" "aws_demo" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform/terraform.tfstate"
  }
}

provider "bigip" {
  alias    = "f5"
  address  = data.terraform_remote_state.aws_demo.outputs.f5_ui
  username = data.terraform_remote_state.aws_demo.outputs.f5_username
  password = data.terraform_remote_state.aws_demo.outputs.f5_password
}


# deploy application using as3
resource "bigip_as3" "nginx_vs1" {
  as3_json = templatefile("../templates/as3-nginx.tmpl", {
    virtual_ip_1 = jsonencode(data.terraform_remote_state.aws_demo.outputs.f5_vs1[0])
    tenant_name  = jsonencode("arch")
    app_name     = jsonencode("nginx")
    consul_uri   = jsonencode("http://${data.terraform_remote_state.aws_demo.outputs.consul_private_ip}:8500/v1/catalog/service/nginx")
  })
  provider      = bigip.f5
  tenant_filter = "arch"

  provisioner "local-exec" {
    command = "while [[ \"$(curl -ski http://${data.terraform_remote_state.aws_demo.outputs.f5_vs1[1]} | grep -Eoh \"^HTTP/1.1 200\")\" != \"HTTP/1.1 200\" ]]; do sleep 5; done"
  }
}

# For testing, writes out to file.

resource "local_file" "test_json" {
  content = templatefile("../templates/as3-nginx.tmpl", {
    virtual_ip_1 = jsonencode(data.terraform_remote_state.aws_demo.outputs.f5_vs1[0])
    tenant_name  = jsonencode("arch")
    app_name     = jsonencode("nginx")
    consul_uri   = jsonencode("http://${data.terraform_remote_state.aws_demo.outputs.consul_private_ip}:8500/v1/catalog/service/nginx")
  })
  filename = "${path.module}/render_test.json"
}