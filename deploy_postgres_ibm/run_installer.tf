############### Input Var #############

variable "admin_password" {
  description = "Postgres admin password"
  type = string 
  default = "postgres"
}

data "ibm_resource_group" "group" {
  name = "default"
}

resource "ibm_database" "jasper_postgres" {
  name              = "jasper_postgres"
  plan              = "standard"
  location          = "us-south"
  service           = "databases-for-postgresql"
  resource_group_id = data.ibm_resource_group.group.id
  adminpassword                = "${var.admin_password}"
  whitelist {
    address     = "169.46.232.1/32"
    description = "desc"
  }
}

output "postgres_connectionstring" {
value = ibm_database.jasper_postgres.connectionstrings.0.composed
}

output "postgres_adminuser" {
value = ibm_database.jasper_postgres.adminuser
}


