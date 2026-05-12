terraform {
  required_version = ">= 1.5.0"
}

resource "null_resource" "configurar_vm" {
  connection {
    type     = "ssh"
    host     = var.vm_ip
    user     = var.vm_user
    password = var.vm_password
    timeout  = "2m"
  }

  provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }
}