source "vmware-iso" "test-image" {
  iso_url          = "image_directory/kali_linux.iso"
  iso_checksum     = "sha256:FFE5AA3932397895257252A144F9C62F2B8663F6B3F8BCF120B5AE53045D6031"
  ssh_username     = "kali"
  ssh_password     = "kali"
  ssh_port         = 22
  ssh_wait_timeout = "60m"
  shutdown_command = "echo 'kali'|sudo -S shutdown -P now"
  vm_name          = "kali"
  boot_wait        = "10s"
  guest_os_type    = "debian8_64"
  disk_size        = 20480
  headless         = false
  http_directory   = "http"
  boot_command = [
    "<esc><wait>",
    "/install.amd/vmlinuz<wait>",
    " auto<wait>",
    " console-setup/ask_detect=false<wait>",
    " console-setup/layoutcode=us<wait>",
    " console-setup/modelcode=pc105<wait>",
    " debconf/frontend=noninteractive<wait>",
    " debian-installer=en_US<wait>",
    " fb=false<wait>",
    " initrd=/install.amd/initrd.gz<wait>",
    " kbd-chooser/method=fr<wait>",
    " netcfg/choose_interface=eth0<wait>",
    " console-keymaps-at/keymap=fr<wait>",
    " keyboard-configuration/xkb-keymap=fr<wait>",
    " keyboard-configuration/layout=FRANCE<wait>",
    " keyboard-configuration/variant=FRANCE<wait>",
    " locale=en_US<wait>",
    " netcfg/get_domain=vm<wait>",
    " netcfg/get_hostname=kali<wait>",
    " grub-installer/bootdev=/dev/sda<wait>",
    " noapic<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg auto=true priority=critical",
    " -- <wait>",
    "<enter><wait>"
  ]
  memory = 4096
  cpus   = 2
}

build {
  sources = [
    "sources.vmware-iso.test-image"
    ]

    provisioner "ansible" {
      playbook_file = "ansible/playbook.yml"
      extra_arguments = [
        "--extra-vars", "ansible_ssh_user=ansible",
        "--extra-vars", "ansible_ssh_pass=ansible",
        "--extra-vars", "ansible_sudo_pass=ansible",
        "--extra-vars", "ansible_become_pass=ansible",
      ]
    }
}


