

/*AWS*/

variable "access_key" {
}
variable "secret_key" {
}
variable "region" {
}

variable "ttl" {
}
variable "zone_id" {
}


/*HETZNER CLOUD*/

variable "hcloud_token" {
}
variable "hcloud_ssh_keys" {
  type = "list"
}

variable "hcloud_location" {
}


variable "hcloud_type_nginxdemo" {
  type = "string"

}

variable "image" {
  type    = "string"
}

variable "hosts_nginxdemo" {
}


variable "hostname_format_nginxdemo" {
  type = "string"
}

variable "domain" {
}

/*VM SETTING*/


variable "apt_packages_nginxdemo" {
  type    = "list"
}

variable "hostame-demo" {
}
variable "reverse-demo" {
}

/*Let's encrypt*/

variable lets-staging{

}