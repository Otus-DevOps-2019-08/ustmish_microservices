resource "google_compute_instance" "app" {
 # name = var.app_name
  name = "app-${count.index + 1}"
  machine_type = "g1-small"
  zone = var.zone
  count = "${var.instance_count}"
  tags = ["reddit-app-stage","reddit-app-prod"]
  boot_disk {
    initialize_params { image = var.app_disk_image }
  }
 
network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.app_ip[count.index].address}"
      # nat_ip = "${element(google_compute_address.app_ip.*.address, count.index)}"
}
  }
  metadata = {
    ssh-keys = "ustmish:${file(var.public_key_path)}"
  }
}

resource "google_compute_address" "app_ip" {
  count = 4
  #name = var.ip_name
   name = "ip-${count.index + 1}"
}

resource "google_compute_firewall" "firewall_puma" {
  name = var.firewall_puma_name
  network = "default"
  allow {
    protocol = "tcp" 
    ports = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app-stage","reddit-app-prod"]
}
