output "external_ip_addres_load_balancer" {
  value = yandex_alb_load_balancer.net_lb.listener.0.endpoint.0.address.0.external_ipv4_address.0.address
}
output "bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}
output "kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
}
output "grafana" {
  value = yandex_compute_instance.grafana.network_interface.0.nat_ip_address
}


output "internal-bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.ip_address
}

output "internal-webserver-1" {
  value = yandex_compute_instance.webserver-1.network_interface.0.ip_address
}

output "internal-webserver-2" {
  value = yandex_compute_instance.webserver-2.network_interface.0.ip_address
}

output "internal-prometheus" {
  value = yandex_compute_instance.prometheus.network_interface.0.ip_address
}

output "internal-grafana" {
  value = yandex_compute_instance.grafana.network_interface.0.ip_address
}

output "internal-elasticsearch" {
  value = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
}

output "internal-kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.ip_address
}

