packer {
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

source "virtualbox-iso" "example-iso" {
    iso_url      = "https://cdimage.kali.org/current/kali-linux-2023.2a-installer-i386.iso"
    iso_checksum = "sha256:567d34e3af1e2504920af552f3edb7fe0e704f11a6099b137e97c986161c9efc"
    boot_wait    = "10s"
    boot_command = [
        "<esc><wait>",
        "<esc><wait>",
        "<enter><wait>",
        "/install/vmlinuz<wait>",
        " initrd=/install/initrd.gz",
        " auto-install/enable=true",
        " debconf/priority=critical",
        " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed_2.cfg<wait>",
        " -- <wait>",
        "<enter><wait>"
      ]
    ssh_username     = "kali"
    ssh_password     = "kali"
    ssh_wait_timeout = "30m"
    http_directory = "http"
    shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  }
  
  build {
    sources = ["virtualbox-iso.example-iso"]
    
    provisioner "shell" {
      script = "provisioner.sh"
    }
    
    post-processor "vagrant" {
      output  = "wocsa-kali-{{ user `timestamp` }}.box"
    }
  }
  