variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "login_password" {
  type = string
}

variable "login_username" {
  type = string
}

variable "fqdn" {
  type = string
}

variable "MONITORING_BASIC_AUTH" {
  description = "Provide basic auth generated with `htpasswd auth <user>` for monitoring tools"
}
