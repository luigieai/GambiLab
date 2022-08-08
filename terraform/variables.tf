variable "tenancy_ocid" {
}

variable "current_user_ocid" {
}
variable "ssh_public_key" {
}

variable "compartment_ocid" {
}

variable "region" {
}

variable "arm_shape" {
    default = "VM.Standard.A1.Flex"
}

variable "arm_image" {
    description = "To grab image ID use the command commented below "
    //oci compute image list --operating-system 'Canonical Ubuntu' --compartment-id ocid1.compartment.oc1..aaaaaaaac5kc6qfkvneoqlxkk5rgnwog57bcdeah2kmpyrjye5yjrdelz52a --shape VM.Standard.A1.Flex
    // https://docs.oracle.com/en-us/iaas/tools/oci-cli/2.17.0/oci_cli_docs/cmdref/compute/image/list.html
    default = "ocid1.image.oc1.us-sanjose-1.aaaaaaaa3prdpji4w36ni2blanuvbg2w3byebux3vqvtd6yc2uiryy5ge33a"
}