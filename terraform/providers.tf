terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Bloquea la versión en la rama 3.x para evitar cambios que rompan el código
    }
  }

  backend "azurerm" {
     resource_group_name  = "rg-terraform-state-prod"
     storage_account_name = "remotestatetest00"
     container_name       = "tfstate"
     key                  = "practice-aks.tfstate"
   }
}

provider "azurerm" {
  features {
    # Este bloque es obligatorio para el proveedor de Azure.
    # Permite personalizar comportamientos al borrar recursos (ej. borrar discos con la VM).
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}