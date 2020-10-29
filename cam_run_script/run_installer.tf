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
    private_key = "MIICXgIBAAKBgQDNL0n7x9vybN+qOOnPaX0boK7tdntcwukhQ/6luBjTjyjpF55+c34gc1a72z8ezpwUXNji4P+UILFQPIHutrWT9RYMsrJRbfdgVpA+Hlzs8H+Mx+EYwJzh28tpREITaph3K2QYRj8A7Y2aVLg/X4DGF8opFOP0ZnOZ/nL4qkFzrwIDAQABAoGBAMiKra7OmiSJUNoYoj08hzDXjeE96jixsBX5VQw3sNwlkgCwOxKwYtfoox8cnMbJfTdRwBGPg30NrwATA5ODNFfVq3U9AAjvL9CgxYaysIdLGE0oZ3I1rNnklhu2vjID3Y71C2IEmG4hqzDX9uTnWXlHS8iUo3l+EbRuliT0jYWxAkEA8JXQ93e/D0RSZgABoIJcPPMfpPKtIBYM6vlXiIIhI6IyNoRtwjXz7Gw/vpsOKgPw3ro1kyqq7yOMUliiI3lgRQJBANpU0X29VWypIKhV85u2MCDboWbKqgSXCzmjnof8X1Q1YX1z/iAT8VTUk5sMAuEJkVEuhJUnuKVlpCTnFD5eZWMCQA+pEOMq7krmHZ76HSD/m1V0Vfj8uvw9szWQaXw/TDzvj+kwkZx0up4HJdcYbMGbZBB7eoVL37iVTcsGbfd1LSkCQQCKizYgdyuk9zGtAFXEonip8RTbeJEotnw+CDDKFACeG/2QMTG6Q01pyjccNSQCjyKyhDVHvNvzwKrHbAcxiI8HAkEAo/9/btojkOlzavmK0R72tKyFnE1SeMnuilBW/S9ZrSEnYXgDtX1F/aszVRiYTS93W0OCd6ujOj9tZbVglsAB4w=="
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


