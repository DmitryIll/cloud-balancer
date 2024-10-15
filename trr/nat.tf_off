#---- vms --------------

resource "yandex_compute_instance" "nat" {

  name = "nat" 
  hostname = "nat" 

  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  zone                      = "ru-central1-a"

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public.id}" 
    ip_address = "192.168.10.254"
    nat       = "true"
  }

  resources {
    core_fraction = 20 
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size = "16"
    }
  }


  scheduling_policy {
    preemptible = "true"
   }

 metadata = {
    user-data = "${file("./meta.yaml")}" 
  }
}



# старый мусор:
#---------- создаем папки -----

  # provisioner "remote-exec" {
  #   inline = [
  #    "cd ~",
  #    "mkdir -pv configs",
  #    "mkdir -pv docker_volumes",
  #    ]
  # }

# #---------- копируем файлы ----

    # provisioner "file" {
    #   source      = "./id_ed25519"
    #   destination = "/root/.ssh/id_ed25519"
    # }

    # # provisioner "file" {
    # #   source      = "./yctoken"
    # #   destination = "/root/yctoken"
    # # }

    # provisioner "file" {
    #   source      = "./cloudid"
    #   destination = "/root/cloudid"
    # }

    # provisioner "file" {
    #   source      = "./folderid"
    #   destination = "/root/folderid"
    # }

#----------------------------------------------------------

#   provisioner "remote-exec" {
#     inline = "${var.vm[count.index].cmd}"
#   }

#     connection {
#       type        = "ssh"
#       user        = "root"
#       private_key = "${file("id_ed25519")}"
#       host = self.network_interface[0].nat_ip_address
#     }
 

