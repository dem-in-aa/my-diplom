terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.cloud_access_token
  cloud_id  = var.cloud_access_cloud_id
  folder_id = var.cloud_access_folder_id
  zone      = var.zone
}
########################################### - Webservers - ###########################################################

resource "yandex_compute_instance" "webserver-1" {
  name        = "webserver1"
  hostname    = "nginx1"
  zone        = "ru-central1-a"

  resources {
    cores  = var.instance_cores
    memory = var.instance_memory
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_disk
      size     = var.instance_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet-1.id
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.webservers.id]
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
    cores  = var.instance_cores
    memory = var.instance_memory
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_disk
      size     = var.instance_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet-2.id
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.webservers.id]
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
      image_id = var.boot_disk 
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.public-bastion.id]
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
    cores  = var.instance_cores
    memory = var.instance_memory
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_disk
      size     = var.instance_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet-2.id
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.prometheus.id]
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
    cores  = var.instance_cores
    memory = var.instance_memory
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_disk
      size     = var.instance_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.public-grafana.id]
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
    cores  = var.instance_cores
    memory = var.instance_elastic_memory
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_disk
      size     = var.instance_disk_size
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet-2.id
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.elastic.id]
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
    cores  = var.instance_cores
    memory = var.instance_memory
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_disk
      size     = var.instance_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.public-kibana.id]
    ip_address         = "10.0.3.4"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}


