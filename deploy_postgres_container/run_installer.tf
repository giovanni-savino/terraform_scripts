############### Input Var #############
variable "vm_ip" {
  description = "VM IPv4"
}

variable "vm_user" {
  description = "VM User"
}

########## MAIN ####################
resource "null_resource" "run_installer" {

triggers = {
    timestamp = timestamp()
  }

  connection {
    type = "ssh"
    host = "${var.vm_ip}"
    user        = "${var.vm_user}"
    port        = 22
    private_key = "${file("${path.module}/scripts/id_rsa")}"
  }

  provisioner "file" {
    source = "${path.module}/scripts/run_installer_postgres.sh"
    destination = "/tmp/run_installer_postgres.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo su - ",
      "set -e",
      "chmod 755 /tmp/run_installer_postgres.sh",
      "bash -c '/tmp/run_installer_postgres.sh'"
    ]
  }
}


