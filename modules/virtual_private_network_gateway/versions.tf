terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.97"
    }
  }

  required_version = ">= 1.1.0"
  experiments      = [module_variable_optional_attrs]
}
