############### Input Var #############
variable "vm_ip" {
  description = "VM IPv4"
}


variable "external_postgres_url" {
  description = "External postgres url"
  default = "postgres"
}

variable "external_postgres_port" {
  description = "External postgres port"
  default = 5432
}

variable "external_postgres_user" {
  description = "External postgres user"
  default = "postgres"
}

variable "external_postgres_password" {
  description = "External postgres password"
  default = "postgrespassword"
}

########## MAIN ####################
resource "null_resource" "run_installer" {

triggers = {
    timestamp = timestamp()
  }

  connection {
    type = "ssh"
    host = "${var.vm_ip}"
    user        = "root"
    port        = 22
    private_key = "${file("${path.module}/scripts/id_rsa")}"
  }

  provisioner "file" {
    source = "${path.module}/scripts/run_installer_jasper.sh"
    destination = "/tmp/run_installer_jasper.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod 755 /tmp/run_installer_jasper.sh",
      "bash -c '/tmp/run_installer_jasper.sh ${var.external_postgres_url} ${var.external_postgres_port} ${var.external_postgres_user} ${var.external_postgres_password}'"
    ]
  }
}


