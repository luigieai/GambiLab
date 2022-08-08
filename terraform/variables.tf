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
    //oci compute image list --operating-system Canonical Ubuntu 
    // https://docs.oracle.com/en-us/iaas/tools/oci-cli/2.17.0/oci_cli_docs/cmdref/compute/image/list.html
    default = "vocid1.image.oc1.us-sanjose-1.aaaaaaaawu6gqwohgcs7ggd5xx64pw5ebl7ij5gijgnbxnhqnqrdc2kihqlq"
}