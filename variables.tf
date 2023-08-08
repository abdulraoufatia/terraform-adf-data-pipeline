variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "UK South"
}

variable "storage_account_name" {
  description = "The name of the Azure Storage Account."
  type        = string
}

variable "storage_container_source_name" {
  description = "The name of the source Azure Storage Container."
  type        = string
  default     = "source"
}

variable "storage_container_destination_name" {
  description = "The name of the destination Azure Storage Container."
  type        = string
  default     = "destination"
}

variable "data_factory_name" {
  description = "The name of the Azure Data Factory."
  type        = string
}

variable "linked_service_name" {
  description = "The name of the Azure Data Factory Linked Service."
  type        = string
}

variable "source_dataset_name" {
  description = "The name of the source custom dataset."
  type        = string
  default     = "sourcedataset"
}

variable "destination_dataset_name" {
  description = "The name of the destination custom dataset."
  type        = string
  default     = "destinationdataset"
}

variable "pipeline_name" {
  description = "The name of the pipeline."
  type        = string
  default     = "etlpipeline"
}
