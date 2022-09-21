variable "tags" {
  type        = map(string)
  default     = { terraform_managed = "true" }
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "default region to deploy eks cluster us-east-1(ireland)"
}

variable "profile" {
  type        = string
  default     = "default"
  description = "aws profile"
}
