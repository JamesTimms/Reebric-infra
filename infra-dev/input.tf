variable "region" {
  description = "Sets the GCP region"
  type        = string
}

variable "zone" {
  description = "Sets the GCP zone"
  type        = string
}

variable "project_name" {
  description = "The given name for the project"
  type        = string
}

variable "billing_account" {
  description = "[secret] The billing account details"
  type        = string
}

variable "org_id" {
  description = "[secret] The organisation ID"
  type        = string
}

variable network_name {
  description = "The name given to the VPC network. Change requires relaunch of resource."
  type        = string
}

# variable host_project_id {
#   description = "The id of the VPC host project"
#   type        = string
# }

# variable service_project_ids {
#   description = "The ids of all service projects"
#   type        = list(string)
#   default     = []
# }
