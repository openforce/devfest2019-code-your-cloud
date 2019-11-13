# variable "hcloud_token" {}

provider "hcloud" {
    token = "64lbOtq9U9zjhvCfw7JEqLik6mdqn251oApaSBWRJnQnQyUfWPsCZ7c2zz8oicA0"
}

data "hcloud_image" "k8_master" {
  with_selector  = "name=k8-master"
}

output "imageid" {
  value="${data.hcloud_image.k8_master.id}"
}

resource "tls_private_key" "generated_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}


resource "hcloud_ssh_key" "gh" {
  name = "main ssh key"
  public_key = "${generated_key.public_key_pem}"
}

resource "hcloud_server" "k8-master" {
  count = 1
  name = "master-${count.index}"
  image = "${data.hcloud_image.k8_master.id}"
  server_type = "cx21"
  datacenter = "nbg1-dc3"
  ssh_keys = ["${hcloud_ssh_key.gh.name}"]
}

resource "hcloud_server" "k8-node" {
  count = 2
  name = "node-${count.index}"
  image = "${data.hcloud_image.k8_master.id}"
  server_type = "cx21"
  datacenter = "nbg1-dc3"
  ssh_keys = ["${hcloud_ssh_key.gh.name}"]
}
