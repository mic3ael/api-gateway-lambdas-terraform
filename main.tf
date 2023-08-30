locals {
  env          = terraform.workspace
  servicesPath = "services"
}

module "iac_handlers" {
  source = "./modules/iac-handlers"
  env    = local.env
  lambdas = [{
    output_path   = "${path.module}/${local.servicesPath}/permutation/archive_files/function.zip",
    function_name = "permutation",
    timeout       = 300,
    handler       = "src/index.handler"
    runtime       = "nodejs18.x"
    source_dir    = "${path.module}/${local.servicesPath}/permutation/function"
  }]
}

module "iac-gateway" {
  source  = "./modules/iac-gateway"
  env     = local.env
  count   = length(module.iac_handlers.lambda_functions)
  targets = [{ lambda : module.iac_handlers.lambda_functions[count.index], endpoint : { route : "permutation", method : "POST", schema : file("${path.module}/${local.servicesPath}/permutation/schema.json") } }]
}
