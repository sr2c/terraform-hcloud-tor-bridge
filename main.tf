resource "random_integer" "obfs_port" {
  min = 1025
  max = 65535
}

resource "random_integer" "or_port" {
  min = 1025
  max = 65535
}

resource "hcloud_server" "this" {
  name        = module.this.id
  image       = "debian-11"
  server_type = "cx11"
  datacenter  = var.datacenter
  ssh_keys    = [var.ssh_key_name]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt install -y apt-transport-https gnupg2",
      "echo 'deb     [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org bullseye main' | sudo tee /etc/apt/sources.list.d/tor.list",
      "echo 'deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org bullseye main' | sudo tee -a /etc/apt/sources.list.d/tor.list",
      "wget -O- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null",
      "sudo apt update",
      "sudo apt install -y tor tor-geoipdb deb.torproject.org-keyring obfs4proxy"
    ]
  }

  provisioner "file" {
    content = <<-EOT
    BridgeRelay 1
    ORPort ${random_integer.or_port.result}
    ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy
    ServerTransportListenAddr obfs4 0.0.0.0:${random_integer.obfs_port.result}
    ExtORPort auto
    ContactInfo ${var.contact_info}
    Nickname ${replace(title(module.this.id), module.this.delimiter, "")}
    BridgeDistribution ${var.distribution_method}
    EOT
    destination = "/etc/tor/torrc"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown root:root /etc/tor/torrc",
      "sudo chmod 644 /etc/tor/torrc",
      "sudo systemctl restart tor"
    ]
  }

  connection {
    host = self.ipv4_address
    type = "ssh"
    user = var.ssh_user
    private_key = var.ssh_private_key
    timeout = "5m"
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
  command = "ssh -o StrictHostKeyChecking=no ${var.ssh_user}@${hcloud_server.this.ipv4_address} sudo cat /var/lib/tor/pt_state/obfs4_bridgeline.txt | tail -n 1"
}

module "fingerprint_ed25519" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no ${var.ssh_user}@${hcloud_server.this.ipv4_address} sudo cat /var/lib/tor/fingerprint-ed25519"
}

module "fingerprint_rsa" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no ${var.ssh_user}@${hcloud_server.this.ipv4_address} sudo cat /var/lib/tor/fingerprint"
}

module "hashed_fingerprint" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no ${var.ssh_user}@${hcloud_server.this.ipv4_address} sudo cat /var/lib/tor/hashed-fingerprint"
}