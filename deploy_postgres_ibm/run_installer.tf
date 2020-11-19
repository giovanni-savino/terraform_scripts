############### Input Var #############

variable "admin_password" {
  description = "Postgres admin password"
  default = "Jasper123"
}

variable "ip_whitelist" {
  description = "IP VM front-end"
  default = "169.46.232.1"
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
  adminpassword     = var.admin_password
  whitelist {
    address     = join("",[var.ip_whitelist,"/32"])
    description = "Ip front-end"
  }
}

output "postgres_connectionstring" {
value = ibm_database.jasper_postgres.connectionstrings.0.composed
}

output "postgres_adminuser" {
value = ibm_database.jasper_postgres.adminuser
}


output "postgres_host" {
  description = "Url"
  value       = ibm_database.jasper_postgres.connectionstrings.0.hosts.0.hostname
}

output "postgres_port" {
  description = "Port"
  value       = ibm_database.jasper_postgres.connectionstrings.0.hosts.0.port
}