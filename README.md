# infra-program-nginx-packer

Automatically provision Nginx in an EC2 instance with Terraform, Packer and Ansible

## Prerequisites

- [AWS](https://aws.amazon.com/) account & access tokens. Configure a profile to include in the variables
- [Packer](https://www.packer.io/) installed
- [Ansible](https://www.ansible.com/) installed
- [Terraform](https://www.terraform.io/) installed
- [AWS CLI](https://aws.amazon.com/cli/) version 2 installed
- I would recommend to also install a Terraform version manager such as [tfenv](https://github.com/tfutils/tfenv)

## How it works

First we'll create an Nginx [golden image](https://en.wiktionary.org/wiki/golden_image) using Ansible and Packer. With the golden image we can automate the creation of VMs. 

Packer needs a custom vpc with a subnet and a public ip to generate the AMI.

1) Create the ssh credentials:
    - `ssh-keygen -y -f mykeytest.pem > mykeytest.pub`
    - Copy them in `~/.ssh/` in your laptop (adapt to your needs)
2) Get the token using AWS CLI
3) `terraform init` to configure the project
4) `terraform plan` to prepare the provisioning
5) `terraform apply` to create the network (SSH Key, VPC, Subnet, Security Group, etc). As the `ami` in the `aws_instance` is empty the result is an error
6) Copy `vpc-id` and `subnet-id` to Packer file `ami.pkr.hcl`
   1) `module.network.aws_vpc.vpc_ccb: Creation complete after 1s [id=`**vpc-XXXXXXX**`]`
   2) `module.network.aws_subnet.subnets["web"]: Creation complete after 11s [id=`**subnet-XXXXX**`]`      
7) With this information we can create the Nginx `AMI` with the Ansible `playbook.yml` by running:
   1) `packer validate .`
   2) `packer build .`
8) Copy the result of Packer execution `ami-XXXX`. We can use `AWS CLI` to inspect the created `AMI` and find the `ImageId`:
   1) `$ aws ec2 describe-images --owner self --profile <your-profile> --region <your-region>`
9) Fill in `variables.tf` the `ami` var with the `AMI` or `ImageId` just copied
10) Execute again `terraform apply` to create the EC2 instance with the Nginx golden image
11) Access the `custom_public_ip` given as a result of terraform execution and Nginx welcome page should appear 
12) `terraform destroy` to remove all the resources from AWS
13) Since the image was not created with terraform we separately should:
    1) Deregister the image `$aws ec2 deregister-image --profile <your-profile> --region <your-region> --image-id <your-ami-id>`
    2) Find the Snapshot Id `$aws ec2 describe-snapshots --owner self --profile <your-profile> --region <your-region>`
    3) Delete snapshot `$aws ec2 delete-snapshot --profile <your-profile> --region <your-region> --snapshot-id <your-snap-id>`

## Material

- [Immutable Infrastructure in AWS with Packer, Ansible and Terraform](https://dev.to/codingsafari/immutable-infrastructure-in-aws-with-packer-ansible-and-terraform-5dhi)