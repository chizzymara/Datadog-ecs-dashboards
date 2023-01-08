locals {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

resource "datadog_dashboard_json" "dashboard_json" {
  dashboard = templatefile(var.dashboard_filepath, var.variable_dict)
}

data "aws_ssm_parameter" "api_key" {
  name = local.api_key
}

data "aws_ssm_parameter" "app_key" {
  name = local.app_key
}

