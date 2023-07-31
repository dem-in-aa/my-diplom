
resource "yandex_vpc_network" "network" {
  name = "my-network"
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "my-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "internal-to-nat" {
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
   gateway_id         = yandex_vpc_gateway.nat_gateway.id
   # next_hop_address   = yandex_compute_instance.bastion.network_interface.0.ip_address
  }
}

resource "yandex_vpc_subnet" "private-subnet-1" {
  name           = "private-subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.internal-to-nat.id
}

resource "yandex_vpc_subnet" "private-subnet-2" {
  name           = "private-subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.internal-to-nat.id
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public-subnet"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.3.0/24"]
}

############################################## - target_group - ##########################################################

resource "yandex_alb_target_group" "target_group" {
  name = "my-target-group"

  target {
    ip_address = yandex_compute_instance.webserver-1.network_interface.0.ip_address
    subnet_id  = yandex_vpc_subnet.private-subnet-1.id
  }

  target {
    ip_address = yandex_compute_instance.webserver-2.network_interface.0.ip_address
    subnet_id  = yandex_vpc_subnet.private-subnet-2.id
  }
}

############################################# - backend_group - #########################################################

resource "yandex_alb_backend_group" "my_alb_bg" {
  name = "my-backend-group"

  http_backend {
    name             = "http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.target_group.id]
    load_balancing_config {
      panic_threshold = 90
    }
    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

############################################# - HTTP router - ###########################################################

resource "yandex_alb_http_router" "http_router" {
  name = "http-router"
}

resource "yandex_alb_virtual_host" "root_virtual_host" {
  name           = "root-virtual-host"
  http_router_id = yandex_alb_http_router.http_router.id
  route {
    name = "root-path"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.my_alb_bg.id
        timeout          = "3s"
      }
    }
  }
}

############################################ - L7 balancer - ############################################################

resource "yandex_vpc_address" "address" {
  name = "exampleAddress"

  external_ipv4_address {
    zone_id = "ru-central1-b"
  }
}

resource "yandex_alb_load_balancer" "net_lb" {
  name               = "net-load-balancer"
  network_id         = yandex_vpc_network.network.id

allocation_policy {
    location {
      zone_id          = "ru-central1-a"
      subnet_id        = yandex_vpc_subnet.private-subnet-1.id
    }

    location {
      zone_id          = "ru-central1-b"
      subnet_id        = yandex_vpc_subnet.private-subnet-2.id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.address.external_ipv4_address[0].address 
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http_router.id
      }
    }
  }
}


