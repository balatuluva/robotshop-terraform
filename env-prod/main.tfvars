#components = {
#  frontend = {
#    name = "frontend"
#    instance_type = "t3.small"
#  }
#  mongodb = {
#    name = "mongodb"
#    instance_type = "t3.small"
#  }
#  catalogue = {
#    name = "catalogue"
#    instance_type = "t3.micro"
#  }
#  redis = {
#    name = "redis"
#    instance_type = "t3.small"
#  }
#  user = {
#    name = "user"
#    instance_type = "t3.micro"
#  }
#  cart = {
#    name = "cart"
#    instance_type = "t3.micro"
#  }
#  mysql = {
#    name = "mysql"
#    instance_type = "t3.small"
#  }
#  shipping = {
#    name = "shipping"
#    instance_type = "t3.medium"
#  }
#  rabbitmq = {
#    name = "rabbitmq"
#    instance_type = "t3.small"
#  }
#  payment = {
#    name = "payment"
#    instance_type = "t3.small"
#  }
#  dispatch = {
#    name = "dispatch"
#    instance_type = "t3.small"
#  }
#}
#
#env = "prod"

env = "prod"
monitor_cidr = ["172.31.44.59/32"]
bastion_cidr = ["172.31.40.134/32"]
default_vpc_id = "vpc-06cc0012016b947fe"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_rtid = "rtb-086ecde1fe849c0d5"
kms_arn = "arn:aws:kms:us-east-1:313587121011:key/b4ef00c9-7aa3-4bba-ad5d-54544604bbaa"
domain_name = "gehana26.fun"
domain_id = "Z0695756SMJXHSSK5PKP"

vpc = {
  main = {
    cidr_block = "10.100.0.0/16"
    subnets = {
      public = {
        name = "public"
        cidr_block = ["10.100.0.0/24", "10.100.1.0/24"]
        azs = ["us-east-1a", "us-east-1b"]
      }
      web = {
        name = "web"
        cidr_block = ["10.100.2.0/24", "10.100.3.0/24"]
        azs = ["us-east-1a", "us-east-1b"]
      }
      app = {
        name = "app"
        cidr_block = ["10.100.4.0/24", "10.100.5.0/24"]
        azs = ["us-east-1a", "us-east-1b"]
      }
      db = {
        name = "db"
        cidr_block = ["10.100.6.0/24", "10.100.7.0/24"]
        azs = ["us-east-1a", "us-east-1b"]
      }
    }
  }
}

app = {
  frontend = {
    name = "frontend"
    instance_type = "t3.small"
    subnet_name = "web"
    allow_app_cidr = "public"
    desired_capacity = 2
    max_size = 10
    min_size = 2
    app_port = 80
    listener_priority = 1
    lb_type = "public"
    dns_name = "www"
    parameters = []
  }
  catalogue = {
    name = "catalogue"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 10
    min_size = 2
    app_port = 8080
    listener_priority = 2
    lb_type = "private"
    parameters = ["docdb"]
  }
  user = {
    name = "user"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 10
    min_size = 2
    app_port = 8080
    listener_priority = 3
    lb_type = "private"
    parameters = ["docdb"]
  }
  cart = {
    name = "cart"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 10
    min_size = 2
    app_port = 8080
    listener_priority = 4
    lb_type = "private"
    parameters = []
  }
  payment = {
    name = "payment"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 10
    min_size = 2
    app_port = 8080
    listener_priority = 5
    lb_type = "private"
    parameters = []
  }
  shipping = {
    name = "shipping"
    instance_type = "t3.medium"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 10
    min_size = 2
    app_port = 8080
    listener_priority = 6
    lb_type = "private"
    parameters = ["rds"]
  }
}

docdb = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    engine_version = "4.0.0"
    instance_count = 1
    instance_class = "db.t3.medium"
  }
}

rds = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    engine_version = "5.7.mysql_aurora.2.11.2"
    instance_count = 1
    instance_class = "db.t3.large"
  }
}

elasticache = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    engine_version = "6.x"
    replicas_per_node_group = 1
    num_node_groups = 1
    node_type = "cache.t3.micro"
  }
}

rabbitmq = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    instance_type = "t3.small"
  }
}

alb = {
  public = {
    name = "public"
    subnet_name = "public"
    allow_alb_cidr = null
    internal = false
  }
  private = {
    name = "private"
    subnet_name = "app"
    allow_alb_cidr = "web"
    internal = true
  }
}