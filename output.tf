output "storage_account_name" {
  value = azurerm_storage_account.aatia-sa.name
}

output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.aatia-sa.primary_access_key
  sensitive = true
}