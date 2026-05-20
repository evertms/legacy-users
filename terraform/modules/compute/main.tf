data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nodejs npm git
              
              cd /home/ec2-user
              git clone https://github.com/evertms/legacy-users.git
              cd legacy-users
              
              npm install
              
              export PORT=${var.app_port}
              export NODE_ENV=produccion
              nohup npm start > /var/log/app.log 2>&1 &
              EOF

  tags = {
    Name = "LegacyUsers-EC2"
  }
}