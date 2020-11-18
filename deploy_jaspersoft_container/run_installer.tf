############### Input Var #############
variable "vm_ip" {
  description = "VM IPv4"
}

variable "vm_user" {
  description = "VM User"
}

variable "postgres_url" {
  description = "Postgres url"
  default = "postgres"
}

variable "postgres_port" {
  description = "Postgres port"
  default = 5432
}

variable "postgres_user" {
  description = "Postgres user"
  default = "postgres"
}

variable "postgres_password" {
  description = "Postgres password"
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
    user        = "${var.vm_user}"
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
      "if [ `id -u` = 0 ] ; then bash -c '/tmp/run_installer_postgres.sh ${var.postgres_url} ${var.postgres_port} ${var.postgres_user} ${var.postgres_password}' ; else sudo bash -c '/tmp/run_installer_postgres.sh ${var.postgres_url} ${var.postgres_port} ${var.postgres_user} ${var.postgres_password}';  fi "
    ]
  }
}


