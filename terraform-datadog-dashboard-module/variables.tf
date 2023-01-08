variable "dashboard_filepath" {
  description = "the file path of the dashboard json file"
  type        = string
}

variable "variable_dict" {
  description = "the variables to be replaced in the dashboard json file"
  type        = map(any)
}


variable "datadog_api_key" {
  description = "ssm parameter name used to identify datadog api key "
  type        = string
}

variable "datadog_app_key" {
  description = "ssm parameter name used to identify datadog api key"
  type        = string
}