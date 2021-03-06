##############################################################################
# Account Variables
# Copyright 2020 IBM
##############################################################################

# Comment this variable if running in schematics
variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
  sensitive   = true
}

# Comment out if not running in schematics
variable TF_VERSION {
 default     = "1.0"
 description = "The version of the Terraform engine that's used in the Schematics workspace."
}

variable prefix {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "gcat-multizone"

    validation  {
      error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
      condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
    }
}

variable region {
  description = "Region where VPC will be created"
  type        = string
  default     = "us-south"
}

variable resource_group {
    description = "Name of resource group where all infrastructure will be provisioned"
    type        = string
    default     = "gcat-landing-zone-dev"

    validation  {
      error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
      condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
    }
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable vpc_name {
   description = "The name of the VPC where VSI will be deployed"
   type        = string
}

variable subnet_name {
    description = "A subnet name in VPC where VSI will be created"
    type        = list(string)
}

variable ssh_key_names {
  description = "A list of ssh key names to be used for access to the bastion host"
  type       = list(string)
  default    = []

  validation {
    error_message = "At least one SHH key name must be provided."
    condition     = length(var.ssh_key_names) > 0
  }
}

##############################################################################


##############################################################################
# APP ID Variables
##############################################################################

variable appid_name { 
  description = "Name of APP ID instance"
  type        = string
}

variable appid_resource_key_name {
  description = "Name of the APP ID instance resource key"
  type        = string
}

##############################################################################


##############################################################################
# APP ID Variables
##############################################################################

variable cos_name { 
  description = "Name of COS instance"
  type        = string
}

variable cos_resource_key_name {
  description = "Name of the COS instance resource key. Must be HMAC credentials"
  type        = string
}

variable cos_bucket { 
  description = "Data of the COS bucket to store the session recordings"
  type        = object({
    name        = string
    region      = optional(string) # If a region is not provided, the vpc region will be used
    bucket_type = string
  })

  default = {
    name        = "example-bucket"
    bucket_type = "region_location"
  }

  validation {
    error_message = "Cos bucket type can only be one of `single_site_location`, `region_location`, `cross_region_location."
    condition     = var.cos_bucket.bucket_type == "single_site_location" || var.cos_bucket.bucket_type == "region_location" || var.cos_bucket.bucket_type == "cross_region_location" 
  }
}

##############################################################################


##############################################################################
# Template Variables
##############################################################################

variable teleport_license_pem {
  description = "The contents of the PEM license file"
  type        = string
}

variable https_cert {
  description = "The https certificate"
  type        = string 
}

variable https_key {
  description = "The https key"
  type        = string
}

variable domain {
  description = "The domain of the instance or bastion host"
  type        = string
}

variable teleport_version {
  description = "Version of Teleport Enterprise to use"
  type        = string
  default     = "7.1.3"
}

variable claims_to_roles {
  description = "A list of maps that contain the user email and the role you want to associate with them"
  type        = list(
    object({
      email = string
      roles = list(string)
    })
  )
  default = [
    # Example claims
    #{
    #  email = "user@test.com",
    #  roles = ["teleport-admin"]
    #},
    #{
    #  email = "test@gmail.com",
    #  roles = ["teleport-admin2"]
    #}
  ]
}

variable message_of_the_day {
  description = "Banner message the is exposed to the user at authentication time"
  type        = string
  default     = "Welcome"
}

##############################################################################


##############################################################################
# Virtual Server Variables
##############################################################################

variable security_group_names {
  description = "A list of additional security groups to add to the primary interface of the VSI"
  type        = list(string)
  default     = []
}

variable image {
  description = "The image to be used for the bastion host"
  type        = string
}

variable profile {
  description = "The profile to be used for the bastion host"
  type        = string
}

##############################################################################