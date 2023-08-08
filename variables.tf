variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be provisioned."
  type        = string
}

variable "source_storage_account_name" {
  description = "Name of the source storage account."
  type        = string
}

variable "destination_storage_account_name" {
  description = "Name of the destination storage account."
  type        = string
}

variable "source_container_name" {
  description = "Name of the source container."
  type        = string
}

variable "destination_container_name" {
  description = "Name of the destination container."
  type        = string
}
