resource "oci_core_virtual_network" "gatonet" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "gatonet"
  dns_label      = "gatonet"
}

resource "oci_core_subnet" "gatonet_subnet" {
  cidr_block        = "10.0.1.0/24"
  display_name      = "public_gatonet"
  dns_label         = "public.gatonet"
  security_list_ids = [oci_core_security_list.gatonet_guardinha.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.gatonet.id
  route_table_id    = oci_core_route_table.gatonet_route_table.id
  dhcp_options_id   = oci_core_virtual_network.gatonet.default_dhcp_options_id
}

resource "oci_core_security_list" "gatonet_guardinha" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.gatonet.id
  display_name   = "guardinha"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3000"
      min = "3000"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3005"
      min = "3005"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }
}
resource "oci_core_internet_gateway" "gatonet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "gatonet_gateway"
  vcn_id         = oci_core_virtual_network.gatonet.id
}

resource "oci_core_route_table" "gatonet_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.gatonet.id
  display_name   = "gatonet_routetable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.gatonet_gateway.id
  }
}
