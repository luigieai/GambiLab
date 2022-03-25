/*
Servers mapping initial idea:
ARM: 
  - 2 servers VM.Standard.A1.Flex
  - 12GB RAM  
  - 2 OCPU 
  - 65GB storage 
*/


resource "oci_core_instance" "arm_01" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "tank01"
  shape               = var.arm_shape

  shape_config {
    ocpus = 2
    memory_in_gbs = "12"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.gatonet_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "tank01"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.ubuntu_image.images[0], "id")
    boot_volume_size_in_gbs = 65
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
  }
}

resource "oci_core_instance" "arm_02" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "tank02"
  shape               = var.arm_shape

  shape_config {
    ocpus = 2
    memory_in_gbs = "12"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.gatonet_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "tank01"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.ubuntu_image.images[0], "id")
    boot_volume_size_in_gbs = 65
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
  }
}

// OS Images
data "oci_core_images" "ubuntu_image" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.4"
  //shape                    = var.arm_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

// Server SSH Key
resource "tls_private_key" "compute_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "server_pem" {
  value     = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.private_key_pem
  sensitive = true
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}