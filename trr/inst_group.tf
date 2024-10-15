resource "yandex_compute_instance_group" "lamp-group" {
  name                = "lamp-group-with-balancer"
#   folder_id           = "b1g6k2i3lobiesnh55af"
   service_account_id  = "aje2271kkvefi1el32vv"
  #deletion_protection = "<защита_от_удаления:_true_или_false>"
  
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"  # LAMP
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.cloud-net.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat       = true
    }


    metadata = {
    ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgAWJRB1phor3yFZd/GZBaVIZUzYc8KyrpSzQnEH7lJ user@worknout}"
    serial-port-enable = "1"
    user-data  = <<EOF
#!/bin/bash
cd /var/www/html
echo '<html><head><title>Cat</title></head> <body><h1>Hello!</h1><img src="http://s3bucket2.website.yandexcloud.net/cat"/></body></html>' > index.html
EOF
    }


    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

   allocation_policy {
     zones = ["ru-central1-a"]
   }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval = 30
    timeout  = 10
    tcp_options {
      port = 80
    }
  }

  load_balancer {
    target_group_name        = "target-group-lamp"
    target_group_description = "load balancer target group lamp"
  }
}

