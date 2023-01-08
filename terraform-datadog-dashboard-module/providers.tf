terraform {
  required_version = ">= 1.1.5"
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = ">= 3.1.2"
    }
  }
}
# Configure the Datadog provider
provider "datadog" {
  api_key = data.aws_ssm_parameter.api_key.value
  app_key = data.aws_ssm_parameter.app_key.value
}
