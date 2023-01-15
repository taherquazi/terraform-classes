resource "aws_instance" "aws-ins-1" {

  subnet_id              = aws_subnet.sub-1.id
  vpc_security_group_ids = [aws_security_group.sg-1.id]
  ami                    = var.aws_ami_name
  instance_type          = var.instance_type_name
  user_data              = <<EOF
#! /bin/bash
sudo yum install nginx -y
sudo rm -f /usr/share/nginx/html/index.html
echo "Server-1" | sudo tee -a /usr/share/nginx/html/index.html
sudo service nginx start  
EOF

  tags = local.common_tags
}

resource "aws_instance" "aws-ins-2" {

  subnet_id              = aws_subnet.sub-2.id
  vpc_security_group_ids = [aws_security_group.sg-1.id]
  ami                    = var.aws_ami_name
  instance_type          = var.instance_type_name
  user_data              = <<EOF
#! /bin/bash
sudo yum install nginx -y
sudo rm -f /usr/share/nginx/html/index.html
echo "Server-2" | sudo tee -a /usr/share/nginx/html/index.html
sudo service nginx start  
EOF

  tags = local.common_tags
}
