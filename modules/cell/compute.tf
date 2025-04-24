resource "aws_security_group" "ec2" {
  name        = "${var.environment}-${var.cell_name}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "${var.environment}-${var.cell_name}-ec2-sg"
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public[0].id
  key_name      = aws_key_pair.this.key_name

  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "${var.environment}-${var.cell_name}-ec2"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
resource "aws_key_pair" "this" {
  key_name   = "${var.environment}-${var.cell_name}-key"
  public_key = file("/Users/anaprimo/.ssh/id_rsa.pub") 
}