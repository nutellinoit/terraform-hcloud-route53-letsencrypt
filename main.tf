/* general */

provider "hcloud" {
  token = "${var.hcloud_token}"
}

resource "hcloud_server" "host_nginxdemo" {
  name        = "${format(var.hostname_format_nginxdemo, count.index + 1)}"
  location    = "${var.hcloud_location}"
  image       = "${var.image}"
  server_type = "${var.hcloud_type_nginxdemo}"
  ssh_keys    = ["${var.hcloud_ssh_keys}"]

  count = "${var.hosts_nginxdemo}"

  provisioner "remote-exec" {
    inline = [
      "while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 1; done",
      "apt-get update",
      "apt-get install -yq ufw ${join(" ", var.apt_packages_nginxdemo)}",
      "curl https://releases.rancher.com/install-docker/17.03.2.sh | sh",
      "curl https://get.acme.sh | sh",
      "docker run -d --restart=unless-stopped -p 81:2368 ghost"

    ]
    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }


}


resource "null_resource" "add-conf-nginx-demo" {
  count = "${var.hosts_nginxdemo}"

  connection {
    host = "${element(hcloud_server.host_nginxdemo.*.ipv4_address, count.index)}"
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source     = "template.vhosts.conf"
    destination = "/etc/nginx/conf.d/${var.hostame-demo}.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "export  AWS_ACCESS_KEY_ID=${var.access_key}",
      "export  AWS_SECRET_ACCESS_KEY=${var.secret_key}",
      "sed -i 's/HOSTNAME/${var.hostame-demo}/g' /etc/nginx/conf.d/${var.hostame-demo}.conf",
      "sed -i 's#REVERSEURL#${var.reverse-demo}#g' /etc/nginx/conf.d/${var.hostame-demo}.conf",
      "~/.acme.sh/acme.sh --issue ${var.lets-staging} --dns dns_aws -d ${var.hostame-demo}",
      "service nginx reload",
    ]
  }

}


resource "aws_route53_record" "demo_nutellino_it" {
  zone_id = "${var.zone_id}"
  name    = "demo"
  type    = "A"
  ttl     = "${var.ttl}"
  records = ["${hcloud_server.host_nginxdemo.*.ipv4_address}"]
}


output "hostnames_nginxdemo" {
  value = ["${hcloud_server.host_nginxdemo.*.name}"]
}

output "public_ips_nginxdemo" {
  value = ["${hcloud_server.host_nginxdemo.*.ipv4_address}"]
}
