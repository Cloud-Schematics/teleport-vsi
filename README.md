# Teleport Bastion VSI

IBM Virtual Private Cloud (VPC) comes with an additional layer of security as your workload can be completely hidden from the public internet. There are times, however, when you will want to get into this private network. A common practice is to use a Bastion host to jump into your VPC from a machine outside of the private network.

This module deploys a bastion server using Teleportinside a VPC Virtual Server Instance (VSI) using Terraform. This module is based on [https://github.com/cloud-native-toolkit/terraform-vsi-bastion-teleport](https://github.com/cloud-native-toolkit/terraform-vsi-bastion-teleport)

## Prereqs

1. Provision an instance of Object Storage and configure a bucket for storing session recordings.
1. Provision an instance of App ID and configure a SAML-based identity provider.
1. Acquire a Teleport Enterprise Edition license

### Terraform providers

- IBM Cloud provider >= 1.31

## Module Variables

Name                    | Type                                                                     | Description                                                                             | Sensitive | Default
----------------------- | ------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- | --------- | --------------------------------------------------------------------
ibmcloud_api_key        | string                                                                   | The IBM Cloud platform API key needed to deploy IAM enabled resources                   | true      | 
TF_VERSION              |                                                                          | The version of the Terraform engine that's used in the Schematics workspace.            |           | 1.0
prefix                  | string                                                                   | A unique identifier need to provision resources. Must begin with a letter               |           | gcat-multizone
region                  | string                                                                   | Region where VPC will be created                                                        |           | us-south
resource_group          | string                                                                   | Name of resource group where all infrastructure will be provisioned                     |           | gcat-landing-zone-dev
vpc_name                | string                                                                   | The name of the VPC where VSI will be deployed                                          |           | 
subnet_name             | list(string)                                                             | A subnet name in VPC where VSI will be created                                          |           | 
ssh_key_names           | list(string)                                                             | A list of ssh key names to be used for access to the bastion host                       |           | []
appid_name              | string                                                                   | Name of APP ID instance                                                                 |           | 
appid_resource_key_name | string                                                                   | Name of the APP ID instance resource key                                                |           | 
cos_name                | string                                                                   | Name of COS instance                                                                    |           | 
cos_resource_key_name   | string                                                                   | Name of the COS instance resource key. Must be HMAC credentials                         |           | 
cos_bucket              | object({ name = string region = optional(string) bucket_type = string }) | Data of the COS bucket to store the session recordings                                  |           | {<br>name = "example-bucket"<br>bucket_type = "region_location"<br>}
teleport_license_pem    | string                                                                   | The contents of the PEM license file                                                    |           | 
https_cert              | string                                                                   | The https certificate                                                                   |           | 
https_key               | string                                                                   | The https key                                                                           |           | 
domain                  | string                                                                   | The domain of the instance or bastion host                                              |           | 
teleport_version        | string                                                                   | Version of Teleport Enterprise to use                                                   |           | 7.1.3
claims_to_roles         | list( object({ email = string roles = list(string) }) )                  | A list of maps that contain the user email and the role you want to associate with them |           | [ ]
message_of_the_day      | string                                                                   | Banner message the is exposed to the user at authentication time                        |           | Welcome
security_group_names    | list(string)                                                             | A list of additional security groups to add to the primary interface of the VSI         |           | []
image                   | string                                                                   | The image to be used for the bastion host                                               |           | 
profile                 | string                                                                   | The profile to be used for the bastion host                                             |           | 
