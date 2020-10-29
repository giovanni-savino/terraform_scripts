############### Input Var #############
variable "vm_ip" {
  description = "VM IPv4"
}

########## MAIN ####################
resource "null_resource" "run_installer" {

  connection {
    type = "ssh"
    host = "${var.vm_ip}"
    user        = "root"
    private_key = "${file("${path.module}/scripts/id_rsa")}"
  }

  provisioner "file" {
    source = "${path.module}/scripts/run_installer.sh"
    destination = "/tmp/run_installer.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod 755 /tmp/run_installer.sh",
      "bash -c '/tmp/run_installer.sh'"
    ]
  }
}


