
variable "bucket_name" {
  type        = string
  description = "Имя s3 backet"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

# variable "token" {
#   type        = string
#   description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
# }

# variable "cloud_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
# }



# variable "default_zone" {
#   type        = string
#   default     = "ru-central1-a"
#   description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
# }
# variable "default_cidr" {
#   type        = list(string)
#   default     = ["10.0.1.0/24"]
#   description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
# }

# variable "vpc_name" {
#   type        = string
#   default     = "develop"
#   description = "VPC network&subnet name"
# }

# variable "public_subnet" {
#   type        = string
#   default     = "public-subnet"
#   description = "subnet name"
# }



# # ---
# variable count_vm {
#   default = 0
# }

# variable "vm" {
#   type = list(
#     object({
#       name = string
#       image = string
#       cpu = number
#       core_fraction = number
#       ram = number
#       disk_size = number
#       allow_stopping   = bool
#       platform = string
#       zone = string
#       preemptible = bool
#       nat = bool
#       cmd = list(string)
#     })
#   )
#   description = "параметры ВМ"
# }