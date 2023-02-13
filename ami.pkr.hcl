## Use your AWS account profile
## Copy vpc_id and subnet_id after first terraform apply
source "amazon-ebs" "example" {
  profile         = ""
  vpc_id          = ""
  subnet_id       = ""
  ssh_timeout     = "30s"
  region          = ""
  source_ami      = "ami-0db9040eb3ab74509"
  ssh_username    = "ec2-user"
  ami_name        = "packer nginx"
  instance_type   = "t2.micro"
  skip_create_ami = false
}

build {
  sources = [
    "source.amazon-ebs.example"
  ]
  provisioner "ansible" {
    playbook_file = "playbook.yml"
    ansible_ssh_extra_args = [
      "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
    extra_arguments = [
      "--scp-extra-args", "'-O'"
    ]
  }
}
