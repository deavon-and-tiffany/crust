build {
  sources = [
    "source.arm.ubuntu"
  ]

  provisioner "file" {
    source      = "overlay/"
    destination = "/"
  }

  provisioner "shell" {
    inline = [
      "mkdir -p ${local.setup_dir}",
      "chmod ugo=rwX ${local.setup_dir}",
    ]
  }

  provisioner "file" {
    source      = "scripts/"
    destination = local.setup_dir
  }


  provisioner "shell" {
    environment_vars = [
      "GITHUB_TOKEN=${var.github_token}"
    ]
    inline = [
      "${local.setup_dir}/install.sh",
      "rm -rf /workspace",
      "rm -rf /temp/*"
    ]
  }

  post-processor "checksum" {
    checksum_types = [
      "md5",
      "sha1",
      "sha256"
    ]
    output = "images/${local.image_name}.{{.ChecksumType}}"
  }
}
