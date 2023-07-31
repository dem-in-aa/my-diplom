############################################ - security_group - ##########################################################

### bastion host ###

resource "yandex_vpc_security_group" "public-bastion" {
  name             = "bastion host"
  network_id       = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

### Security group to allow incoming ssh traffic ###

resource "yandex_vpc_security_group" "ssh" {
  name             = "My security group ssh traffic"
  network_id       = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.instance_v4_cidr_blocks   
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

### Security group webservers ###

resource "yandex_vpc_security_group" "webservers" {
  name             = "My security group webservers"
  network_id       = yandex_vpc_network.network.id

  dynamic "ingress" {
    for_each       = ["80", "4040", "8080","9100"]
    content {
    protocol       = "TCP" 
    from_port      = ingress.value
    to_port        = ingress.value
    v4_cidr_blocks = var.instance_v4_cidr_blocks
  }
 }
}

## Security group prometheus ###

resource "yandex_vpc_security_group" "prometheus" {
  name             = "My security group prometheus"
  network_id       = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    from_port      = 9090
    to_port        = 9094
    v4_cidr_blocks = var.instance_v4_cidr_blocks
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
}

### Security group elasticsearch ###

resource "yandex_vpc_security_group" "elastic" {
  name             = "My security group elasticsearch"
  network_id       = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    from_port      = 9200
    to_port        = 9400
    v4_cidr_blocks = var.instance_v4_cidr_blocks
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
}


