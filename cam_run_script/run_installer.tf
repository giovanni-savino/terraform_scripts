############### Input Var #############
variable "vm_ip" {
  description = "VM IPv4"
}

variable "private_key" {
  description = "Private key used for ssh"
}

########## MAIN ####################
resource "null_resource" "run_installer" {

  connection {
    type = "ssh"
    host = "${var.vm_ip}"
    user        = "root"
    private_key = "${var.private_key}"
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


ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKsV0PnM3J2Xa3EFKWG1VnDxW9FZZY+UKuUO4DGZycQdgeOYjDzoTUaSGLa5qdjSBHSpfKma2WOZkZv89UCJTH6Qk51WEjasTKuwMX25NtBCoCE2U4vlJh8UPFwlZnBhrPFuWYPVzdfyYiUqwgI8/pO+RJRuep04MYDNgnDX1k7BnGUsnEq5aIcbhbXTZOr0bFlXc55v11BTTJAMXA0rvLqajdRuHnP+6y5o1okP+y5wwoKBmzM1olyoirYtdrpH4ukcPrjAGMIkGKSeLvF8eo+3C5G0rxJXOC5l+qp8QL/SGhElGLCh3Cprp2SzWTO5sJPej/Ydm584YJPre1qk2uzWGi4W9Je7mkkAREWxdVgZFDzzVZSZ0GgdEWWS5Bih5OMnVgLB2ecLfH7bhK0nxPJje6lOaWDL3UdLs8Iy0b3/anZLWANLHs+/y5c4MDAZz38UT9Hom2nnKpzwEbWyI2mFJZ5OGntFOvVjfQAjRqPmq9PJXqLI7HzITJ5oJLNNqrjwz1mOGA3FdE/niHI8n9hKDhT22EjIa0/RryFU9lcrieaN7Phi3z4kmuPuNm7ZI2fEQXkkziVCj9PxkSimdK5MPqmvhvO8ojAEHTGPlyRc3gER79sXtWZqHXHKNk95a++s6JjGV2pRX/oJEtOOCgKVNOd4VcJVDbBvzt3OBCmw== giovanni.savino@it.ibm.com