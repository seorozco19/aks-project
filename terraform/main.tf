# 1. Grupo de Recursos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Azure Container Registry (ACR) - El almacén de tus imágenes Docker
resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}registry2026" # Debe ser un nombre globalmente único, solo letras y números
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic" # El plan más económico
  admin_enabled       = true
}

# 3. Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks-cluster"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name       = "default"
    node_count = 1               # SÚPER IMPORTANTE: 1 solo nodo para ahorrar costos
    vm_size    = "standard_d2s_v7"  # Tamaño económico de 2 vCPUs y 4GB RAM (Suficiente para laboratorios)
  }

  identity {
    type = "SystemAssigned" # Azure gestionará la identidad del clúster automáticamente
  }

  tags = {
    Environment = "Practice"
  }
}

# 4. El Puente de Permisos (Role Assignment)
# Permite que el AKS (Kubelet) tenga permisos de 'AcrPull' sobre el ACR
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}