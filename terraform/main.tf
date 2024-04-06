### ECR 
resource "aws_ecr_repository" "nextjs_repository" {
  name                 = "nextjs-hello-world"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "nextjs_repository_policy" {
  repository = aws_ecr_repository.nextjs_repository.name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [{
      Sid       = "AllowPullAccess"
      Effect    = "Allow",
      Principal = "*",
      Action    = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    }]
  })
}

resource "aws_ecr_repository_policy" "nextjs_repository_scan_policy" {
  repository = aws_ecr_repository.nextjs_repository.name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [{
      Sid       = "AllowImageScanning"
      Effect    = "Allow",
      Principal = "*",
      Action    = [
        "ecr:PutImageScanningConfiguration",
        "ecr:InitiateLayerScan"
      ]
    }]
  })
}

### EC2

resource "aws_key_pair" "nextjs_vm_keypair" {
  key_name   = "nextjs-vm-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "nextjs_instance" {
  ami             = "ami-053053586808c3e70" 
  instance_type   = "t2.micro"               
  key_name        = aws_key_pair.nextjs_vm_keypair.key_name     
  security_groups = ["allow-ssh-http"]       

  tags = {
    Name = "NextJSEC2Instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -a -G docker ubuntu
              EOF
}

resource "aws_security_group" "allow-ssh-http" {
  name        = "allow-ssh-http"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-http"
  }
}
