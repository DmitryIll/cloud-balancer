#-- создание балансировщика ----

resource "yandex_lb_network_load_balancer" "lb-lamp" {
  name = "network-load-balancer-lamp"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp-group.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      interval = 2
      timeout = 1
      unhealthy_threshold = 2
      healthy_threshold = 5

      http_options {
        port = 80
        path = "/"
      }
    }
  }
}