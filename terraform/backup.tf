resource "yandex_compute_snapshot_schedule" "default" {
  name = "default"

  schedule_policy {
    expression = "0 0 * * *"
  }

  retention_period = "168h"

  snapshot_count = 7

  snapshot_spec {
    description = "daily"
  }

  disk_ids = [yandex_compute_instance.webserver-1.boot_disk[0].disk_id,
              yandex_compute_instance.webserver-2.boot_disk[0].disk_id,
              yandex_compute_instance.bastion.boot_disk[0].disk_id,
              yandex_compute_instance.prometheus.boot_disk[0].disk_id,
              yandex_compute_instance.grafana.boot_disk[0].disk_id,
              yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
              yandex_compute_instance.kibana.boot_disk[0].disk_id]
}
