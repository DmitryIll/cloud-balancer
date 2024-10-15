#---- Создани подсети нужна одна на все ВМ --------------

resource "yandex_vpc_network" "cloud-net" {
  name = "cloud-net"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.cloud-net.id}"
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.20.0/24"]
  network_id     = "${yandex_vpc_network.cloud-net.id}"
  route_table_id = yandex_vpc_route_table.rt-priv.id
}


