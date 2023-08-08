provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform-demo" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.terraform-demo.name
  location                 = azurerm_resource_group.terraform-demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "source-container" {
  name                 = var.storage_container_source_name
  storage_account_name = azurerm_storage_account.mystorageaccount.name
}

resource "azurerm_storage_container" "destination-container" {
  name                 = var.storage_container_destination_name
  storage_account_name = azurerm_storage_account.mystorageaccount.name
}

resource "azurerm_data_factory" "adf-terraform" {
  name                = var.data_factory_name
  resource_group_name = azurerm_resource_group.terraform-demo.name
  location            = azurerm_resource_group.terraform-demo.location
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "my-linked-service" {
  name            = var.linked_service_name
  data_factory_id = azurerm_data_factory.adf-terraform.id

  connection_string = azurerm_storage_account.mystorageaccount.primary_connection_string
}

resource "azurerm_data_factory_custom_dataset" "source-dataset" {
  name            = var.source_dataset_name
  data_factory_id = azurerm_data_factory.adf-terraform.id
  type            = "Json"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.my-linked-service.name
    parameters = {
      key1 = "value1"
    }
  }

  type_properties_json = jsonencode({
    location = {
      container  = azurerm_storage_container.source-container.name
      fileName   = "test.csv"
      folderPath = ""
      type       = "AzureBlobStorageLocation"
    }
    encodingName = "UTF-8"
  })

  description = "Source dataset description"
  annotations = ["sourcedataset_tag"]

  schema_json = jsonencode({
    type = "object",
    properties = {
      Month = { type = "string" },
      "1958" = { type = "integer" },
      "1959" = { type = "integer" },
      "1960" = { type = "integer" },
    }
  })
}

resource "azurerm_data_factory_custom_dataset" "destination-dataset" {
  name            = var.destination_dataset_name
  data_factory_id = azurerm_data_factory.adf-terraform.id
  type            = "Json"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.my-linked-service.name
    parameters = {
      key1 = "value1"
    }
  }

  type_properties_json = jsonencode({
    location = {
      container  = azurerm_storage_container.destination-container.name
      fileName   = "test.csv"
      folderPath = ""
      type       = "AzureBlobStorageLocation"
    }
    encodingName = "UTF-8"
  })

  description = "Destination dataset description"
  annotations = ["destinationdataset_tag"]

  schema_json = jsonencode({
    type = "object",
    properties = {
      Month = { type = "string" },
      "1958" = { type = "integer" },
      "1959" = { type = "integer" },
      "1960" = { type = "integer" },
    }
  })
}

resource "azurerm_data_factory_pipeline" "etl-pipeline" {
  name            = var.pipeline_name
  data_factory_id = azurerm_data_factory.adf-terraform.id

  activities_json = jsonencode([
    {
      "name" : "CopyDataActivity",
      "type" : "Copy",
      "inputs" : [
        {
          "referenceName" : azurerm_data_factory_custom_dataset.source-dataset.name,
          "type" : "DatasetReference"
        }
      ],
      "outputs" : [
        {
          "referenceName" : azurerm_data_factory_custom_dataset.destination-dataset.name,
          "type" : "DatasetReference"
        }
      ],
      "typeProperties" : {
        "source" : {
          "type" : "DelimitedTextSource",
          "storeSettings" : {
            "type" : "AzureBlobFSReadSettings",
            "recursive" : true
          }
        },
        "sink" : {
          "type" : "DelimitedTextSink",
          "storeSettings" : {
            "type" : "AzureBlobFSWriteSettings"
          }
        }
      }
    }
  ])
}
