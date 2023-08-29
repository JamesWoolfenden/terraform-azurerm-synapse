variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map
}


variable "key_vault_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "object_id" {
  type = string
  description = "(optional) describe your variable"
}

variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_id" {
  type = string
}