terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.32.1"
    }
    template = {
      source = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
  experiments = [ module_variable_optional_attrs ]
}