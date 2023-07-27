terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = ""                                                           ###### OAuth-token
  cloud_id  = "b1god8fqtrgpq04am4iq"                                       ###### Идентификатор облака (cloud-dem-in-aa)
  folder_id = "b1gvoeoqlur5mogja8je"                                       ###### Идентификатор каталога (default)
  zone      = "ru-central1-b"
}
#
#variable "vars_file" {
#  description = "/secret.tfvars"
#  type        = string
#}

#locals {
#  my_vars = file(var.vars_file)
#}

#provider "yandex" {
#  token     = (/secret.tfvars)["token"]
#  cloud_id  = (/secret.tfvars)["cloud_id"]
#  folder_id = (/secret.tfvars)["folder_id"]
#}

#provider "yandex" {
#  token     = var.cloud_access_token
#  cloud_id  = var.cloud_access_cloud_id
#  folder_id = var.cloud_access_folder_id
#  zone      = var.zone
#}
########################################### - Webservers - ###########################################################

resource "yandex_compute_instance" "webserver-1" {
  name        = "webserver1"
  hostname    = "nginx1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oshj0osht8svg6rfs"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet-1.id
    security_group_ids = [yandex_vpc_security_group.internal-subnets.id]
    ip_address         = "10.0.1.3"
  }


  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "webserver-2" {
  name        = "webserver2"
  hostname    = "nginx2"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oshj0osht8svg6rfs"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet-2.id
    security_group_ids = [yandex_vpc_security_group.internal-subnets.id]
    ip_address         = "10.0.2.3"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

############################################ - bastion-host - ##########################################################

resource "yandex_compute_instance" "bastion" {
  name        = "vm-bastion"
  hostname    = "bastion"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oshj0osht8svg6rfs" 
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.internal-subnets.id, yandex_vpc_security_group.public-bastion.id]
    ip_address         = "10.0.3.5"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}


############################# - prometheus - ########################################

resource "yandex_compute_instance" "prometheus" {
  name        = "vm-prometheus"
  hostname    = "prometheus"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oshj0osht8svg6rfs"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet-2.id
    security_group_ids = [yandex_vpc_security_group.internal-subnets.id]
    ip_address         = "10.0.2.5"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

######################### - grafana - ######################################

resource "yandex_compute_instance" "grafana" {
  name        = "vm-grafana"
  hostname    = "grafana"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oshj0osht8svg6rfs"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.internal-subnets.id, yandex_vpc_security_group.public-grafana.id]
    ip_address         = "10.0.3.3"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

########################### - elasticsearch - #############################################

resource "yandex_compute_instance" "elasticsearch" {
  name        = "vm-elastic"
  hostname    = "elasticsearch"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 8
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oshj0osht8svg6rfs"  #debian11
     # image_id = "fd8tf1sepeiku6d37l4l" #ubuntu
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet-2.id
    security_group_ids = [yandex_vpc_security_group.internal-subnets.id]
    ip_address         = "10.0.2.4"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

############################### - kibana - ################################################

resource "yandex_compute_instance" "kibana" {
  name        = "vm-kibana"
  hostname    = "kibana"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oshj0osht8svg6rfs"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.internal-subnets.id, yandex_vpc_security_group.public-kibana.id]
    ip_address         = "10.0.3.4"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}


