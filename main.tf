locals {
  env = terraform.workspace
}

module "iac_handlers" {
  source = "./modules/iac-handlers"
  env    = local.env
}

module "iac-gateway" {
  source  = "./modules/iac-gateway"
  env     = local.env
  targets = [{ lambda : module.iac_handlers.permutation_lambda_function_data, endpoint : { route : "permutation", method : "POST", schema : file("${path.module}/schemas/permutation.json") } }]
}
