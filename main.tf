provider "aws" {
  region = "us-east-1"
}

# Crear el par de claves para la instancia EC2
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Crear el Security Group
resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crear la instancia EC2
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # AMI Ubuntu
  instance_type = "t2.micro"
  key_name      = aws_key_pair.jenkins_key.key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = file("install_jenkins.sh") # Script de configuración (ver más abajo)

  tags = {
    Name = "Jenkins-Server"
  }
}
