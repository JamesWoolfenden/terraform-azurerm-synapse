terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.71.0"
    }
  }
  required_version = ">= 1.5"

  # local state is intentional for this example; use a remote backend in real deployments
  backend "local" {}
}
