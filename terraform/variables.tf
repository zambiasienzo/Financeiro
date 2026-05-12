variable "vm_ip" {
  default = "177.44.248.57"
}

variable "vm_user" {
  default = "univates"
}

variable "vm_password" {
  description = "Senha SSH da VM"
  type        = string
  sensitive   = true
}