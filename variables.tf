variable "contact_info" {
  type        = string
  description = "Contact information to be published in the bridge descriptor."
}

variable "server_type" {
  type        = string
  description = "Name of the server type to use for the compute instance."
  default     = "cx11"
}

variable "datacenter" {
  type        = string
  description = "Datacenter to deploy the instance in."
}

variable "ssh_private_key" {
  type        = string
  description = "Filename of private SSH key for provisioning."
}

variable "ssh_user" {
  type        = string
  description = "Username to use for SSH access (must have password-less sudo enabled)."
  default     = "root"
}

variable "distribution_method" {
  type        = string
  description = "Bridge distribution method"
  default     = "any"

  validation {
    condition     = contains(["https", "moat", "email", "settings", "none", "any"], var.distribution_method)
    error_message = "Invalid distribution method. Valid choices are https, moat, email, settings, none or any."
  }
}