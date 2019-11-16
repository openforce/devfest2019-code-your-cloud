variable "hcloud_token" {}
variable "gitlab_token" {}

provider "hcloud" {
    token = "${var.hcloud_token}"
}

data "hcloud_image" "gitlab_runner" {
  with_selector  = "name=gitlab-runner"
}

resource "tls_private_key" "generated_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "hcloud_ssh_key" "gh" {
  name = "main ssh key"
#  public_key = "${tls_private_key.generated_key.public_key_openssh}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "hcloud_server" "runner" {
  count = 2
  name = "gl-runner-${count.index}"
  image = "${data.hcloud_image.gitlab_runner.id}"
  server_type = "cx21"
  datacenter = "nbg1-dc3"
  ssh_keys = ["${hcloud_ssh_key.gh.name}"]
  provisioner "remote-exec" {
    inline = [
      "gitlab-runner register --non-interactive --url 'https://git.openforce.com' --registration-token ${var.gitlab_token} --executor 'docker' --docker-image alpine:latest --description 'docker-runner' --tag-list 'docker' --run-untagged='true' --locked='false' --access-level='not_protected'"
    ]
    connection {
      type     = "ssh"
      user     = "root"
      host     = "${self.ipv4_address}"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

  }
}
