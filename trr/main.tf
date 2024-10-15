# #---- vms --------------

# resource "yandex_compute_instance" "vm" {

#   #  count = "${var.count_vm}"
#   count = length(var.vm)

#   name = "${var.vm[count.index].name}" 
#   hostname = "${var.vm[count.index].name}" 

#   allow_stopping_for_update = "${var.vm[count.index].allow_stopping}"
#   platform_id               = "${var.vm[count.index].platform}"
#   zone                      = "${var.vm[count.index].zone}"

#   resources {
#     core_fraction = "${var.vm[count.index].core_fraction}" 
#     cores  = "${var.vm[count.index].cpu}" 
#     memory = "${var.vm[count.index].ram}"  
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "${var.vm[count.index].image}"
#       size = "${var.vm[count.index].disk_size}"
#     }
#   }

#   network_interface {
#     subnet_id = "${yandex_vpc_subnet.subnet-1.id}" 
#     nat       = "${var.vm[count.index].nat}"
#   }

#   scheduling_policy {
#   preemptible = "${var.vm[count.index].preemptible}"
#    }

#  metadata = {
#     user-data = "${file("./meta.yaml")}" 
#   }

# #---------- создаем папки -----

#   # provisioner "remote-exec" {
#   #   inline = [
#   #    "cd ~",
#   #    "mkdir -pv configs",
#   #    "mkdir -pv docker_volumes",
#   #    ]
#   # }

# # #---------- копируем файлы ----

#     provisioner "file" {
#       source      = "./id_ed25519"
#       destination = "/root/.ssh/id_ed25519"
#     }

#     # provisioner "file" {
#     #   source      = "./yctoken"
#     #   destination = "/root/yctoken"
#     # }

#     provisioner "file" {
#       source      = "./cloudid"
#       destination = "/root/cloudid"
#     }

#     provisioner "file" {
#       source      = "./folderid"
#       destination = "/root/folderid"
#     }

# #----------------------------------------------------------

#   provisioner "remote-exec" {
#     inline = "${var.vm[count.index].cmd}"
#   }

#     connection {
#       type        = "ssh"
#       user        = "root"
#       private_key = "${file("id_ed25519")}"
#       host = self.network_interface[0].nat_ip_address
#     }
 
# }




