# Azure Data Factory Project

This project demonstrates how to set up an Azure Data Factory using Terraform. It creates Azure resources such as a Resource Group, Storage Account, Storage Containers, Azure Data Factory, Linked Service, Custom Datasets, and a Pipeline.

## Prerequisites

Before you begin, ensure you have:

- **Azure Subscription**: You need an active Azure subscription. Ensure you have a Microsoft Azure account, this will enable you to create a subscription.

- **Terraform Installed**: Make sure you have Terraform installed on your local machine.
   - Windows OS: You would need to install Chocolatey Package Manager. You can find  intructions to install Chocolatey here https://chocolatey.org/install

   - MAC OS: You would need to install Homebrew. You can find instructions to install Homebrew here at https://brew.sh

- **Azure Command Line Interface**: Ensure you have the Azure CLI installed. You can find instructions to your OS here https://learn.microsoft.com/en-us/cli/azure/install-azure-cli 
   - Windows OS: From 12-Aug-23 there three methods to install AZURE CLI
      - Package Manager
      - Microsoft Installer (MSI)
      - Microsoft Installer (MSI) wtih Command 


      
      Follow instructions on your prefered method of installation.  

   - Ensure you have configured the AZ CLI

## Setup

1. Clone this repository:

   ```sh
   git clone https://github.com/abdulraoufatia/terraform-adf-data-pipeline.git
   ```
2. Create a file named `terraform.tfvars` in the root directory of this project.
3. Copy the content from `terraform.tfvars.template` and paste it into `terraform.tfvars`.
3. Modify the values in `terraform.tfvars` according to your preferences. Ensure your storage account name is globally unique

```
# Azure Resource Group
resource_group_name = "my-terraform-demo"
location            = "UK South"  # Change this to your preferred Azure region

# Azure Storage Account
storage_account_name = "<your-storageaccount-name>" # must be globaly unique

# Storage Container Names
storage_container_source_name      = "source-container"
storage_container_destination_name = "destination-container"

# Azure Data Factory
data_factory_name = "my-data-factory"

# Linked Service (Azure Blob Storage)
linked_service_name          = "my-linked-service"

# Source Custom Dataset
source_dataset_name = "source-dataset"

# Destination Custom Dataset
destination_dataset_name = "destination-dataset"

# Data Factory Pipeline
pipeline_name = "etl-pipeline"

```
5. Save the `terraform.tfvars` file.

# Deployment
1. Open a command prompt or terminal window and navigate to the root directory of this project.
2. Run the following commands:

```sh
terraform init
terraform apply -auto-approve
```

This will initialise Terraform and apply the configuration using the values from `terraform.tfvars`.

3. Confirm the deployment by typing `yes` when prompted.

4. Once the deployment is complete, Terraform will display the output values, including the storage account name and primary access key.

# Usage
1. Log in to the Azure Portal.
2. Locate the provisioned Azure Data Factory resource named "adf-terraform".
3. Configure your data movement pipeline:
    - Create datasets based on the configured source and destination containers.
    - Create a pipeline with a copy activity using these datasets.
4. Monitor pipeline runs and manage activities in the Azure Data Factory portal.

# Cleanup
When finished, clean up resources to avoid ongoing charges:

1. Destroy the created resources:
 ```sh
   terraform destroy
   ```

2. Confirm destruction by entering `yes` when prompted.

# Note
- Always ensure sensitive information like access keys, secrets, and connection strings are kept secure and not directly exposed in your code or public repositories.

- This example focuses on demonstrating the Terraform setup for an Azure Data Factory and related resources. In a real-world scenario, you might need to adjust the configuration to meet your specific requirements.


# Contributing
Contributions are welcome! If you encounter issues or want to enhance the project, submit pull requests.

# License
This project is open-source and available under the MIT License.