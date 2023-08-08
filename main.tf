provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform-demo" {
  name     = "terraform-demo"
  location = "UK South" # Change this to your preferred Azure region
}

resource "azurerm_storage_account" "aatia-sa" {
  name                     = "terraformdemoaatia"
  resource_group_name      = azurerm_resource_group.terraform-demo.name
  location                 = azurerm_resource_group.terraform-demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "source" {
  name                 = "source"
  storage_account_name = azurerm_storage_account.aatia-sa.name
}

resource "azurerm_storage_container" "destination" {
  name                 = "destination"
  storage_account_name = azurerm_storage_account.aatia-sa.name
}

resource "azurerm_data_factory" "adf-terraform-atia" {
  name                = "adf-terraform-atia"
  resource_group_name = azurerm_resource_group.terraform-demo.name
  location            = azurerm_resource_group.terraform-demo.location
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "aatia1" {
  name              = "aatia1"
  data_factory_id   = azurerm_data_factory.adf-terraform-atia.id
  connection_string = azurerm_storage_account.aatia-sa.primary_connection_string
}

resource "azurerm_data_factory_custom_dataset" "sourcedataset" {
  name            = "sourcedataset"
  data_factory_id = azurerm_data_factory.adf-terraform-atia.id
  type            = "Json"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.aatia1.name
    parameters = {
      key1 = "value1"
    }
  }

  type_properties_json = jsonencode({
    location = {
      container  = azurerm_storage_container.source.name
      fileName   = "foo.txt"
      folderPath = "foo/bar/"
      type       = "AzureBlobStorageLocation"
    }
    encodingName = "UTF-8"
  })

  description = "Source dataset description"
  annotations = ["sourcedataset_tag"]

  parameters = {
    foo = "source_test1"
    Bar = "source_test2"
  }

  schema_json = jsonencode({
    type = "object"
    properties = {
      name = {
        type = "object"
        properties = {
          firstName = {
            type = "string"
          }
          lastName = {
            type = "string"
          }
        }
      }
      age = {
        type = "integer"
      }
    }
  })
}

resource "azurerm_data_factory_custom_dataset" "destinationdataset" {
  name            = "destinationdataset"
  data_factory_id = azurerm_data_factory.adf-terraform-atia.id
  type            = "Json"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_blob_storage.aatia1.name
    parameters = {
      key1 = "value1"
    }
  }

  type_properties_json = jsonencode({
    location = {
      container  = azurerm_storage_container.destination.name
      fileName   = "output.txt"
      folderPath = "output/bar/"
      type       = "AzureBlobStorageLocation"
    }
    encodingName = "UTF-8"
  })

  description = "Destination dataset description"
  annotations = ["destinationdataset_tag"]

  parameters = {
    foo = "destination_test1"
    Bar = "destination_test2"
  }

  schema_json = jsonencode({
    type = "object"
    properties = {
      name = {
        type = "object"
        properties = {
          firstName = {
            type = "string"
          }
          lastName = {
            type = "string"
          }
        }
      }
      age = {
        type = "integer"
      }
    }
  })
}

resource "azurerm_data_factory_pipeline" "pipeline" {
  name            = "etlpipeline"
  data_factory_id = azurerm_data_factory.adf-terraform-atia.id

  activities_json = jsonencode([
    {
      "name" : "CopyDataActivity",
      "type" : "Copy",
      "inputs" : [
        {
          "referenceName" : "${azurerm_data_factory_custom_dataset.sourcedataset.name}",
          "type" : "DatasetReference"
        }
      ],
      "outputs" : [
        {
          "referenceName" : "${azurerm_data_factory_custom_dataset.destinationdataset.name}",
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