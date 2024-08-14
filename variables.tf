###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}
variable "sa_name" {
  description = "Name for the service account"
  default     = "administrator"
  type        = string
}
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

### vpc vars

variable "VPC_name" {
  type        = string
  default     = "my-vpc"
}
### cp_vpc node vars

variable "cp_vpc_name" {
  type        = string
  default     = "control-plane"
}

variable "platform" {
  type        = string
  default     = "standard-v1"
}

variable "cp_vpc_core" {
  type        = number
  default     = "4"
}

variable "cp_vpc_memory" {
  type        = number
  default     = "8"
}

variable "cp_vpc_fraction" {
  description = "guaranteed vCPU, for yandex cloud - 20, 50 or 100 "
  type        = number
  default     = "20"
}

variable "cp_vpc_disk_size" {
  type        = number
  default     = "50"
}

variable "image_id" {
  type        = string
  default     = "fd893ak78u3rh37q3ekn"
}

variable "scheduling_policy" {
  type        = bool
  default     = "true"
}

### work noda  vars

variable "work_count" {
  type        = number
  default     = "2"
}

variable "work_platform" {
  type        = string
  default     = "standard-v1"
}

variable "work_cores" {
  type        = number
  default     = "4"
}

variable "work_memory" {
  type        = number
  default     = "2"
}

variable "work_core_fraction" {
  description = "guaranteed vCPU, for yandex cloud - 20, 50 or 100 "
  type        = number
  default     = "20"
}

variable "work_disk_size" {
  type        = number
  default     = "50"
}

variable "nat" {
  type        = bool
  default     = "true"
}

### metadata
variable "metadata" {
  type        = map(string)
  default     = {
    "serial-port-enable" = "1"
    "ssh-keys" = "centos:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYAW7jxrBt5gElaLR6x5Jcy8rgaEM6mxfCGAHswroVS root@sv-1"
  }
  description = "ssh-keygen -t ed25519"
}

### subnet vars

variable "public_subnet_name" {
  type        = string
  default     = "public"
}

variable "public_v4_cidr_blocks" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
}

variable "subnet_zone" {
  type        = string
  default     = "ru-central1"
}

variable "public_subnet_zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b",  "ru-central1-d"]
}
