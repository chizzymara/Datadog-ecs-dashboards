# Datadog dashboard Terraform module

Terraform module which can create datadog dashboards.

## Usage

### Creating a dashboard on datadog using json file.

```
module  "Datadog_dashboard" {
source = "./terraform-datadog-dashboard-module"
dashboard_filepath =  var.dashboard_filepath
datadog_app_key =  var.datadog_app_key
datadog_api_key =  var.datadog_api_key
}
```


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.5 |
| datadog | >= 3.1.2 |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Providers
### DataDog provider

Datadog provider requires an api_key and app_key which are unique to the each datadog account. You can define them in `terraform.tfvars` file:
```
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
```

## Inputs
The following variables need to be declared. they can be set as default or  added to the `terraform.tfvars`

| Name | Description | Type |
|------|-------------|:----:|
| dashboard_filepath | the file path of the datadog dashboard json file| string |
| datadog_api_key | ssm parameter name used to identify datadog api key| string |
| datadog_app_key | ssm parameter name used to identify datadog app key| string |


## Outputs

| Name | Description |
|------|-------------|
| this_dashboard_url | The url link to the created dashboard|

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Notes

 - For better security, store the secrets (datadog api and app key) safely in encrypted files, secret stores or Environment Variables. this module assumes the use of aws secrets manager parameter store to store the api key and app key. infromation on how to create the parameters can be found here https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-su-create.html

## Authors

Module managed by [Chizzy Mba](https://github.com/chizzymara).
