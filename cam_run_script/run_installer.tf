
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