#
# Apache v2 license
# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

locals {
  sg_whitelist_cidr_blocks = [
    for p in split("\n", file(var.proxy_ip_list)): p
      if replace(p,"/[0-9.]+/[0-9]+/","") != p
  ]
}

resource "oci_core_vcn" "default" {
  display_name = "wsf-${var.job_id}-vcn"
  cidr_blocks = [ var.vpc_cidr_block ]
  compartment_id = var.compartment
  dns_label = "vcn"

  freeform_tags = merge(var.common_tags, {
    Name = "wsf-${var.job_id}-vcn"
  })
}

resource "oci_core_internet_gateway" "default" {
  display_name = "wsf-${var.job_id}-igw"
  compartment_id = var.compartment
  enabled = true
  vcn_id = oci_core_vcn.default.id

  freeform_tags = merge(var.common_tags, {
    Name = "wsf-${var.job_id}-igw"
  })
}

resource "oci_core_subnet" "default" {
  display_name = "wsf-${var.job_id}-subnet"
  availability_domain = var.zone
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 1)
  compartment_id = var.compartment
  dns_label = "subnet"
  vcn_id = oci_core_vcn.default.id

  freeform_tags = merge(var.common_tags, {
    Name = "wsf-${var.job_id}-subnet"
  })
}

resource "oci_core_default_route_table" "default" {
  display_name = "wsf-${var.job_id}-rt"
  manage_default_resource_id = oci_core_vcn.default.default_route_table_id
  compartment_id = var.compartment
  
  route_rules {
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.default.id
  }

  freeform_tags = merge(var.common_tags, {
    Name = "wsf-${var.job_id}-rt"
  })
}

resource "oci_core_default_security_list" "default" {
  display_name = "wsf-${var.job_id}-sg"
  manage_default_resource_id = oci_core_vcn.default.default_security_list_id
  compartment_id = var.compartment

  dynamic "ingress_security_rules" {
    for_each = toset(local.sg_whitelist_cidr_blocks)

    content {
      description = "SSH"
      protocol = 6 # TCP
      source = ingress_security_rules.key
      source_type = "CIDR_BLOCK"
      stateless = false

      tcp_options {
        min = 22
        max = 22
      }
    }
  }

  ingress_security_rules {
    description = "infra in"
    protocol = "all"
    source = var.vpc_cidr_block
    source_type = "CIDR_BLOCK"
    stateless = false
  }

  egress_security_rules {
    description = "infra out"
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol = "all"
    stateless = false
  }
    
  freeform_tags = merge(var.common_tags, {
    Name  = "wsf-${var.job_id}-sg"
  })
}

