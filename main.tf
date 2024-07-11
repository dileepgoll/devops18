resource "aws_launch_configuration" "web_server_as" {
    image_id           = "ami-0195204d5dce06d99"
    instance_type = "t2.micro"
    key_name = "New"
    security_groups = [aws_security_group.web_server.id]
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-06300be4794aeb670", "subnet-08e6f17e4eceb84a7"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    launch_configuration = aws_launch_configuration.web_server_as.name
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["us-east-1f", "us-east-1c"] 
    
  }

