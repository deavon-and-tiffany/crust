source "arm" "ubuntu" {
  file_urls             = ["http://cdimage.ubuntu.com/releases/${var.version}/release/ubuntu-${var.version}-preinstalled-server-${var.architecture}+raspi.img.xz"]
  file_checksum_url     = "http://cdimage.ubuntu.com/releases/${var.version}/release/SHA256SUMS"
  file_checksum_type    = "sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
  image_build_method    = "resize"
  image_path            = "images/${local.image_name}.img"
  image_size            = "4.5G"
  image_type            = "dos"

  image_partitions {
    name         = "boot"
    type         = "c"
    start_sector = "2048"
    filesystem   = "fat"
    size         = "256M"
    mountpoint   = "/boot/firmware"
  }

  image_partitions {
    name         = "root"
    type         = "83"
    start_sector = "561152"
    filesystem   = "ext4"
    size         = "0"
    mountpoint   = "/"
  }

  image_chroot_env             = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
}
