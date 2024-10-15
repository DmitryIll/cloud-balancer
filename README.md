# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  - Илларионов Дмитрий

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).

Создал, см. файл `trr\backet-s3.tf`

![alt text](image.png)



 - Положить в бакет файл с картинкой.


 ```
 resource "yandex_storage_object" "cat-picture" {
  access_key = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  bucket = var.bucket_name
  key    = "cat"
  source = "./cat.jpg"
  acl = "public-read"
  depends_on = [yandex_storage_bucket.s3backet2]
}
 ```

 Положил:

 ![alt text](image-1.png)

 - Сделать файл доступным из интернета.

Все учел в коде при создании бакета.

Файл открывается по ссылке:

![alt text](image-3.png)

 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.

Создал, см. `\trr\inst_group.tf`

![alt text](image-4.png)

![alt text](image-5.png)


 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 
 ```
     metadata = {
    ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgAWJRB1phor3yFZd/GZBaVIZUzYc8KyrpSzQnEH7lJ user@worknout}"
    serial-port-enable = "1"
    user-data  = <<EOF
#!/bin/bash
cd /var/www/html
echo '<html><head><title>Cat</title></head> <body><h1>Hello!</h1><img src="http://s3bucket2.website.yandexcloud.net/cat"/></body></html>' > index.html
EOF
   }
 ```
 
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.

 ```
     user-data  = <<EOF
#!/bin/bash
cd /var/www/html
echo '<html><head><title>Cat</title></head> <body><h1>Hello!</h1><img src="http://s3bucket2.website.yandexcloud.net/cat"/></body></html>' > index.html
EOF
 ```

 - Настроить проверку состояния ВМ.

```
  health_check {
    interval = 30
    timeout  = 10
    tcp_options {
      port = 80
    }
  }
```

 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.

см. `trr\nlb.tf`

```
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
```
Можно зайти по ip ВМ для начала:

![alt text](image-6.png)


И можно зайти по IP балансера, узнаем его:

```
$ trr console
> yandex_lb_network_load_balancer.lb-lamp
```

Результат:

![alt text](image-7.png)

Смотрим по этому IP:

![alt text](image-8.png)

 - Проверить работоспособность, удалив одну или несколько ВМ.

Выключаю две ВМ любые:

![alt text](image-9.png)

Через балансировщик все продолжает работать:

![alt text](image-10.png)

Еще пробовал погасить и последнюю ВМ а две первых включить - через  некоторое время опять балансировщик их подхватывает, хотя у них уже и новый IP.

4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---
## Задание 2*. AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

Используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к Production like сети Autoscaling group из трёх EC2-инстансов с  автоматической установкой веб-сервера в private домен.

1. Создать бакет S3 и разместить в нём файл с картинкой:

 - Создать бакет в S3 с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать доступным из интернета.
2. Сделать Launch configurations с использованием bootstrap-скрипта с созданием веб-страницы, на которой будет ссылка на картинку в S3. 
3. Загрузить три ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

Resource Terraform:

- [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template).
- [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group).
- [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration).

Пример bootstrap-скрипта:

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
```
### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
