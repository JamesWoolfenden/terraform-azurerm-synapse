variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(any)

  validation {
    condition     = length(var.common_tags) <= 50
    error_message = "Azure resources support at most 50 tags."
  }
}
