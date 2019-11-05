
variable "aws_access_key" {
  default = "dev_cluster"
}
variable "aws_secret_key" {
  default = "dev_cluster"
}

variable "authorized_keys" {
  default = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDB5yOKY9LNho+8FQMSCbtVyPTgKlqeDuHtwtqcOn7I/w5VLZUn2gYMzrC+Hk2SOWQUrHj7M0aEbqzxolR7erKPYKkU94PCd3uHZLRvJ6tOcEuD3fxy0Tkn9NS3012rKi2nWuPOEZ65lhADmYJHz0IkCZKC9WvDf1M6Ax6tWasm769EhBcKe20fYlQKQUYQxE5ws2dw84czf8K2cS3jXJX+ARJcweZjwDyJumcOUnnP3D+NeQ8EK/dPpc61OLJiuTC6abH152KrrT8gS/e1Dcevd/YbBPmRgyO4z1GcYNm/UzKTtP3vUqB5Oi7fF1dCz9FJy7xNz+ZngAt6W+Kq6tWZ deniswamala@Baba.local",
  ]
}

variable "region" {
  default = "us-east-2"
}

variable "master_ami" {
  type = "string"
  #default = "us-east-2"
}