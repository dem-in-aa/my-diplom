variable "cloud_access_token" {
  type = string
  sensitive = true
}

variable "cloud_access_cloud_id" {
  type = string
  sensitive = true
}

variable "cloud_access_folder_id" {
  type = string
  sensitive = true
}


variable "zone" {
  default = "ru-central1-a"
}

variable "instance_v4_cidr_blocks" {
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "boot_disk" {
  type = string
  default = "fd8oshj0osht8svg6rfs"
}

variable "instance_cores" {
  description = "Number of CPU cores for the instance"
  type        = number
  default     = 2
}

variable "instance_memory" {
  description = "Amount of memory for the instance (in GB)"
  type        = number
  default     = 2
}

variable "instance_elastic_memory" {
  description = "Amount of memory for the instance (in GB)"
  type        = number
  default     = 4
}


variable "instance_disk_size" {
  description = "Size of the instance disk (in GB)"
  type        = number
  default     = 10
}
