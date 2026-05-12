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
        "sudo JENKINS_ADMIN_USER='${var.jenkins_admin_user}' JENKINS_ADMIN_PASSWORD='${var.jenkins_admin_password}' /tmp/install.sh > /tmp/install.log 2>&1"
      ]
    }
}