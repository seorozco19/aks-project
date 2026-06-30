variable "resource_group_name" {
  type        = string
  default     = "rg-aks-devops-practice"
  description = "Nombre del Grupo de Recursos"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Región de Azure donde se desplegarán los recursos"
}

variable "prefix" {
  type        = string
  default     = "devopslab"
  description = "Prefijo para dar unicidad a los nombres de los recursos"
}