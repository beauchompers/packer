variable "ssh_password" {
  type    = string
  default = "ubuntu"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

source "virtualbox-iso" "ubuntu-2004" {
  boot_command            = ["<enter><wait2><enter><wait><f6><esc><wait>", " autoinstall<wait2> ds=nocloud-net;", "<wait><enter>"]
  boot_wait               = "5s"
  cpus                    = 2
  floppy_files            = ["./http/user-data", "./http/meta-data"]
  floppy_label            = "cidata"
  format                  = "ova"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "ubuntu-64"
  headless                = false
  http_directory          = "http"
  iso_checksum            = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
  iso_url                 = "http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"
  memory                  = 4096
  shutdown_command        = "echo '${var.ssh_username}'|sudo -S shutdown -P now"
  ssh_handshake_attempts  = "500"
  ssh_password            = "${var.ssh_username}"
  ssh_timeout             = "1200s"
  ssh_username            = "${var.ssh_username}"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "4096"], ["modifyvm", "{{ .Name }}", "--cpus", "2"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "packer-ubuntu-20.04-amd64"
}

build {
  sources = ["source.virtualbox-iso.ubuntu-2004"]

  provisioner "shell" {
    environment_vars = ["SSH_USERNAME=${var.ssh_username}"]
    execute_command  = "echo '${var.ssh_username}' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts          = ["scripts/init.sh", "scripts/vboxadditions.sh", "scripts/cleanup.sh"]
  }

}
