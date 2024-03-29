/*
Servers mapping initial idea:
ARM: 
  - 1 servers VM.Standard.A1.Flex
  - 24GB RAM  
  - 4 OCPU 
  - 130GB storage 
  (one server because host capacity is almost exceeded so it's better to maintain one, and now i plan to run k8s anyways)
*/


resource "oci_core_instance" "arm_01" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "tank01"
  shape               = var.arm_shape

  shape_config {
    ocpus = 4
    memory_in_gbs = "24"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.gatonet_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "tank"
  }

  source_details {
    source_type = "image"
    source_id   = var.arm_image
    boot_volume_size_in_gbs = 130
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
  }
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
  compartment_id = var.compartment_ocid
  ad_number      = 1
}