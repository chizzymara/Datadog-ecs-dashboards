locals {
  datadog_api_key  = "DATADOG_API_KEY" 
  datadog_app_key = "DATADOG_APP_KEY" 
  dashboard_filepath = "templates/dashboard.json" 
}

module "datadog_dashboard" {
  source             = "github.com/chaosgears-terraform-modules/tf-datadog-dashboard?ref=v1.0.0"
  dashboard_filepath = local.dashboard_filepath
  datadog_app_key    = local.datadog_app_key
  datadog_api_key    = local.datadog_api_key
}  
