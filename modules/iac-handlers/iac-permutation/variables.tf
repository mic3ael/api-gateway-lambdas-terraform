variable "region" {
  default = "us-west-2"
}

variable "env" {
  description = "The environment which to fetch the configuration for."
  type        = string
}