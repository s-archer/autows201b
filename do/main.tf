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

# deploy base comfig using declaraitive onboarding

resource "bigip_do"  "do-f5" {
  do_json = templatefile("../templates/do.tmpl", {
    hostname    = jsonencode("f5demo.f5.com"),
    public_ip   = jsonencode("${data.terraform_remote_state.aws_demo.outputs.f5_public_self}/24"),
    private_ip  = jsonencode("${data.terraform_remote_state.aws_demo.outputs.f5_private_self}/24"),
    private_gw  = jsonencode(data.terraform_remote_state.aws_demo.outputs.f5_private_gw),
    public_gw   = jsonencode(data.terraform_remote_state.aws_demo.outputs.f5_public_gw),
    dns         = jsonencode("8.8.8.8"),
    ntp         = jsonencode("time.google.com")
  })
  provider = bigip.f5
  timeout = 5
}

#For testing, writes out to file.

resource "local_file" "test_json" {
    content     = templatefile("../templates/do.tmpl", {
      hostname    = jsonencode("f5demo.f5.com"),
      public_ip   = jsonencode("${data.terraform_remote_state.aws_demo.outputs.f5_public_self}/24"),
      private_ip  = jsonencode("${data.terraform_remote_state.aws_demo.outputs.f5_private_self}/24"),
      private_gw  = jsonencode(data.terraform_remote_state.aws_demo.outputs.f5_private_gw),
      public_gw   = jsonencode(data.terraform_remote_state.aws_demo.outputs.f5_public_gw),
      dns         = jsonencode("8.8.8.8"),
      ntp         = jsonencode("time.google.com")
    })
    filename = "${path.module}/test_do.json"
}