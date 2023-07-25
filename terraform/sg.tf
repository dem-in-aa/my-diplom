############################################ - security_groups - ##########################################################

### bastion host ###

resource "yandex_vpc_security_group" "public-bastion" {
  name             = "bastion host"
  network_id       = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

#  ingress {
#    protocol       = "ICMP"
#    description    = "allow ping"
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

### Internal subnets ###

resource "yandex_vpc_security_group" "internal-subnets" {
  name             = "My internal security group"
  network_id       = yandex_vpc_network.network.id

#  ingress {
#    protocol       = "TCP"
#    description    = "ssh connections from bastion" 
#    port           = 22
#    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#  }
#
#  ingress {
#    protocol       = "ICMP"
#    description    = "ping from bastion"
#    from_port      = 0
#    to_port        = 65535
#    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#  }
#
#  ingress {
#    protocol       = "TCP"
#    description    = "internal http from loadbalancer to webservers"
#    port           = 80
#    predefined_target = "loadbalancer_healthchecks"
#  }
#
#  ingress {
#    protocol       = "TCP"
#    description    = " "
#    port           = 4040
#    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#  }
#
#  ingress {
#    protocol       = "TCP"
#    description    = "prometheus"
#    port           = 9090
#    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] 
#  }
#
#  ingress {
#    protocol       = "TCP"
#    description    = "alert manager"
#    port           = 9093
#    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#  }
#
#  ingress {
#    protocol       = "TCP"
#    description    = "elasticsearch"
#    port           = 9200
#    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#  }

  ingress {
    protocol       = "ANY"
    description    = "allow any connection from internal subnets"
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }


  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

### Security group public network grafana ###

resource "yandex_vpc_security_group" "public-grafana" {
  name        = "My security group public network grafana"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

### Security group public network kibana ###

resource "yandex_vpc_security_group" "public-kibana" {
  name             = "My security group public network kibana"
  network_id       = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}


