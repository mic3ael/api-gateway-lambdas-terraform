variable "targets" {
  type = list(object({
    lambda = object({
      function_name = string,
      invoke_arn    = string
    }),
    endpoint = object({
      route  = string,
      method = string,
      schema = string
    })
  }))
}

variable "env" {
  description = "The environment which to fetch the configuration for."
  type        = string
}
