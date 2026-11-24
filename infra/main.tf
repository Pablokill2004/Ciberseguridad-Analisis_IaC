# Infraestructura de demostracion para el analisis de seguridad IaC.
# Nada de esto se despliega: solo se analiza como codigo.
#
# ESTADO: LINEA BASE INSEGURA (a proposito).
# Los hallazgos se corrigen en el PR de remediacion.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- Red -----------------------------------------------------------------
# El Security Group permite cualquier salida hacia Internet.
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Security group de la aplicacion de demostracion"

  ingress {
    description = "SSH desde la red corporativa"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "HTTP desde la red corporativa"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Salida hacia la red corporativa"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

# --- Computo -------------------------------------------------------------
# IMDSv2 obligatorio, disco cifrado, monitoreo detallado y EBS optimizado.
resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  monitoring    = true
  ebs_optimized = true

  iam_instance_profile   = aws_iam_instance_profile.app.name
  vpc_security_group_ids = [aws_security_group.app.id]

  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }
}

# --- Identidad ------------------------------------------------------------
# Rol e instance profile para que la instancia use credenciales temporales.
resource "aws_iam_role" "app" {
  name = "app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "app" {
  name = "app-profile"
  role = aws_iam_role.app.name
}

# Permisos acotados a un bucket concreto.
resource "aws_iam_policy" "app" {
  name        = "app-lectura-configuracion"
  description = "Lectura acotada del bucket de configuracion"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = [
          "arn:aws:s3:::configuracion-app",
          "arn:aws:s3:::configuracion-app/*",
        ]
      }
    ]
  })
}

# Politica de contrasenas robusta.
resource "aws_iam_account_password_policy" "fuerte" {
  minimum_password_length        = 14
  password_reuse_prevention      = 24
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  max_password_age               = 90
  allow_users_to_change_password = true
}
