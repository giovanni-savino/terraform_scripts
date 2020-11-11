############### Input Var #############
variable "vm_ip" {
  description = "VM IPv4"
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


