##############################################################################
# IBM Cloud Provider
# > Omit this block if using in schematics
##############################################################################

provider ibm {
  ibmcloud_api_key      = var.ibmcloud_api_key
  region                = var.region
  ibmcloud_timeout      = 60
}

##############################################################################


##############################################################################
# Resource Group where VSI Resources Will Be Created
##############################################################################

data ibm_resource_group resource_group {
  name = var.resource_group
}

##############################################################################


##############################################################################
# VPC Data
##############################################################################

data ibm_is_vpc vpc {
  name = var.vpc_name
}

data ibm_is_subnet subnet {
  name = var.subnet_name
}

data ibm_is_ssh_key ssh_key {
  for_each = toset(var.ssh_key_names)
  name     = each.key
}

##############################################################################


##############################################################################
# App ID Data
##############################################################################

data ibm_resource_instance appid { 
  name = var.appid_name
}

data ibm_resource_key appid_resource_key {
  name                  = var.appid_resource_key_name
  resource_instance_id  = data.ibm_is_instance.appid.id
}

##############################################################################


##############################################################################
# COS Data
##############################################################################

data ibm_resource_instance cos { 
  name = var.cos_name
}

data ibm_resource_key cos_resource_key {
  name                  = var.cos_resource_key_name
  resource_instance_id  = data.ibm_is_instance.cos.id
}

data ibm_cos_bucket cos_bucket {
  resource_instance_id = data.ibm_resource_instance.cos.id
  name                 = var.cos_bucket.name
  region               = var.cos_bucket.region == null ? var.region : var.cos_bucket.region
  bucket_type          = var.cos_bucket.bucket_type
}

##############################################################################


##############################################################################
# Teleport Instance
##############################################################################

resource ibm_is_instance teleport_vsi {
  name           = "${var.prefix}-teleport-vsi"
  image          = var.image
  profile        = var.profile
  resource_group = data.ibm_resource_group.rg.id
  vpc            = data.ibm_is_vpc.vpc.id
  zone           = data.ibm_is_subnet.subnet.zone
  user_data      = data.template_cloudinit_config.cloud_init.rendered # From templates.tf

  primary_network_interface {
    subnet          = data.ibm_is_subnet.subnet.id
    security_groups = local.security_group_ids      # From security_groups.tf
  }

  keys = [ 
    for ssh_key in data.ibm_is_ssh_key.ssh_key:
    ssh_key.id
  ]

  //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################