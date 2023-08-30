variable "region" {
  default = "us-west-2"
}

variable "env" {
  description = "The environment which to fetch the configuration for."
  type        = string
}

variable "lambdas" {
  type = list(object({
    output_path   = string,
    function_name = string,
    timeout       = number,
    handler       = string,
    runtime       = string,
    source_dir    = string
  }))
}
