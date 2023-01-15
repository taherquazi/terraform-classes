## aws lb

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-2.id]
  subnets            = [aws_subnet.sub-1.id, aws_subnet.sub-2.id]

  enable_deletion_protection = false

  tags = local.common_tags
}

## aws lb target group

resource "aws_lb_target_group" "lb-target-group" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-1.id

  tags = local.common_tags
}

## aws lb listener

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-group.arn
  }
  tags = local.common_tags
}

## aws lb  target group attachment 

resource "aws_lb_target_group_attachment" "ins-1" {
  target_group_arn = aws_lb_target_group.lb-target-group.arn
  target_id        = aws_instance.aws-ins-1.id
  port             = 80

}

resource "aws_lb_target_group_attachment" "ins-2" {
  target_group_arn = aws_lb_target_group.lb-target-group.arn
  target_id        = aws_instance.aws-ins-2.id
  port             = 80

}
