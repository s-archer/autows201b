variable "f5_ami_search_name" {
  description = "search term to find the appropriate F5 AMI for current region"
  default     = "F5*BIGIP-15.1.0.4*Better*25Mbps*"
}

variable "prefix" {
  description = "prefix used for naming objects created in AWS"
  default     = "arch-tf-201b-"
}



