variable "contact_info" {
  type = string
  description = "Contact information to be published in the bridge descriptor."
}

variable "server_type" {
  type = string
  description = "Name of the server type to use for the compute instance."
  default = "cx11"
}

variable "datacenter" {
  type = string
  description = "Datacenter to deploy the instance in."
}

variable "ssh_key_name" {
  type = string
  description = "Public SSH key name for provisioning. This SSH key must have already been created via the console."
}

variable "distribution_method" {
  type = string
  description = "Bridge distribution method"
  default = "any"

  validation {
    condition     = contains(["https", "moat", "email", "none", "any"], var.distribution_method)
    error_message = "Invalid distribution method. Valid choices are https, moat, email, none or any."
  }
}