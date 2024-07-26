resource "random_integer" "obfs_port" {
  min = 1025
  max = 65535
}

resource "random_integer" "or_port" {
  min = 1025
  max = 65535
}

module "torrc" {
  source                       = "sr2c/torrc/null"
  version                      = "0.0.4"
  bridge_relay                 = 1
  or_port                      = random_integer.or_port.result
  server_transport_plugin      = "obfs4 exec /usr/bin/obfs4proxy"
  server_transport_listen_addr = "obfs4 0.0.0.0:${random_integer.obfs_port.result}"
  ext_or_port                  = "auto"
  contact_info                 = var.contact_info
  nickname                     = replace(title(module.this.id), module.this.delimiter, "")
  bridge_distribution          = var.distribution_method
}

module "cloudinit" {
  source  = "sr2c/tor/cloudinit"
  version = "0.1.1"

  torrc              = module.torrc.rendered
  install_obfs4proxy = true
}

data "tls_public_key" "this" {
  private_key_openssh = file(var.ssh_private_key)
}

data "hcloud_ssh_key" "this" {
  fingerprint = data.tls_public_key.this.public_key_fingerprint_md5
}

resource "hcloud_server" "this" {
  name        = module.this.id
  image       = "debian-11"
  server_type = var.server_type
  datacenter  = var.datacenter
  ssh_keys    = [data.hcloud_ssh_key.this.name]

  user_data = module.cloudinit.rendered

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sleep 30" # Give tor and obfs4proxy time to generate keys and state
    ]
  }

  connection {
    host        = self.ipv4_address
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key)
    timeout     = "10m"
  }

  lifecycle {
    ignore_changes = [
      datacenter,
      image
    ]
  }
}

module "bridgeline" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key} ${var.ssh_user}@${hcloud_server.this.ipv4_address} sudo cat /var/lib/tor/pt_state/obfs4_bridgeline.txt | tail -n 1"
}

module "fingerprint_ed25519" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key} ${var.ssh_user}@${hcloud_server.this.ipv4_address} sudo cat /var/lib/tor/fingerprint-ed25519"
}

module "fingerprint_rsa" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key} ${var.ssh_user}@${hcloud_server.this.ipv4_address} sudo cat /var/lib/tor/fingerprint"
}

module "hashed_fingerprint" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key} ${var.ssh_user}@${hcloud_server.this.ipv4_address} sudo cat /var/lib/tor/hashed-fingerprint"
}
