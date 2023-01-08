

# Setting Up Datadog Dashboards with Terraform


This Repository contains three dashboards that have been designed for monitoring containers on AWS. These dashboards use metrics provided by the AWS ECS integration, Amazon ECS on AWS Fargate Integration, AWS Amazon ELB Integration and passed logs from ECS. 

## Prerequisites

 - Install and configure AWS integration for Datadog. [Guide](https://app.datadoghq.com/integrations/amazon-web-services/add?method=cloud-formation)
 - Install and configure Amazon ECS on AWS Fargate Integration. [Guide](https://docs.datadoghq.com/integrations/ecs_fargate/?tab=webui)
 - Enable container insights for the clusters to be monitored. [Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/deploy-container-insights-ECS-cluster.html]) 
 - Parse Logs with Datadog Log Pipeline. 
 - Store the Datadog api and app keys in AWS Parameter store.


## Dashboards

 - **Containers-main**: Contains ECS running and pending tasks and services, tasks in desired and running state, memory and CPU utilization for clusters and services, Load balancer healthy and unhealthy hosts, request counts per seconds, request time, response time, http responses, processed bytes, active and new connections, uptime, memory usage by containers, IO read and writes, network bytes sent and received and application http responses at a granular level.

 ![Containers-main](img/datadog-container-main-overview.jpg)
 
 
 - **Containers-Summary:** Contains a summary of metrics in the Containers-main dashboard at a high level.
 
 ![Containers-summary](img/datadog-summary-overview.jpg)

 - **Containers-tasks:** Contains CPU utilization metrics, uptime, IO read and writes, memory and networking metrics for Stand-alone tasks (not part of any service).

![Console-tasks](img/datadog-console-tasks-overview.jpg)


## Datadog Module
Terraform module which can create Datadog dashboards from Json templates.


#### Creating a dashboard on Datadog using the module.

```
module "datadog_dashboard" {
  source             = "../modules/terraform-datadog-dashboard"
  dashboard_filepath = var.dashboard_filepath
  datadog_app_key    = var.datadog_app_key
  datadog_api_key    = var.datadog_api_key
  region             = var.region
}  
```

## Terraform Module Requirements

| Name | Version |
| ------ | --------- |
| terraform | >= 1.1.5 |
| datadog | >= 3.1.2 |
| aws | ~> 4.0 |

**DataDog provider**: Datadog provider requires an api_key and app_key which are unique to the each Datadog account. The module requires the secrets to be stored in parameters store.  You can define the parameter names of the api_key and app_key  in `terraform.tfvars` file.

**AWS provider** : AWS provider requires the aws region where ssm parameter secrets will be stored. Region is set as a variable that can be defined in `terraform.tfvars` file

s
### Inputs
The following variables need to be declared. they can be set as default or added to the `terraform.tfvars`

| Name | Description | Type |
|------|-------------|:----:|
| dashboard_filepath | the file path of the datadog dashboard json file| string |
| datadog_api_key | ssm parameter name used to identify datadog api key| string |
| datadog_app_key | ssm parameter name used to identify datadog app key| string |
| region | aws region where ssm parameter secrets will be stored| string |


### Apply Terraform changes
 1. clone the repository 
```console
git clone "repo url"
```
2. Add the required variables to the parameters.tfvars file

3. Configure aws account by running `aws configure`  and adding your aws credentials.
example:

```$ aws configure
  AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
  AWS Secret Access Key[None]:wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  Default region name [None]: us-west-2
  Default output format [None]: json 
   ```
   
4.  Run the terraform command (stores state on the local machine):

	Run `terraform init` from the specific dashboard root directory to initialize the terraform directory .
	Run `terraform plan` to see the plan of the changes to be made and the resources to be created. 
	Run `terraform apply` to apply the changes to your aws account.

### Outputs

| Name | Description |
|------|-------------|
| this_dashboard_url | The url link to the created dashboard|


## Editing the dashboard 

The dashboards created by the module require some preparation to be ready for use. This section details step by step how to get the dashboard ready after deployment. 

 - At the top left corner of the dashboard, click on the dashboard title and select edit to change the title name and add a description.

  ![edit-title](img/datadog-edit-title.jpg)

 - Below the title click on the pencil icon to edit the template variables. With the required integrations (see requirements section) installed and configured, all clusters, services and load balancers will be visible for selection in the drop-down menu. It is possible to add all “available values” by using the plus (+) sign or selecting only the values you want to be monitored by checking on them individually.

  ![edit-template-variable](img/datadog-edit-template-variables.jpg)

 After setting the “available values”, you can make saved views of resources you check frequently.
  ![saved views](img/datadog-saved-view.jpg)
 


 - The container-main dashboard, OS HTTP RESPONSES relies on status code logs from the application. To have the graph populated [see parse logs section](#Parsing-Logs-on-Datadog-Pipeline) below. 


 <a name="Parsing-Logs-on-Datadog-Pipeline"></a>
## Parsing Logs on Datadog Pipeline
 - Navigate to logs and click on search to see all the logs.
 - Click on any of the logs to see more details about the logs. If the status_code is available within the event attributes, no further actions is needed to have the graph populated.
 - If the status_code is not parsed to the event attributes. But available within the logs, it can be parsed with the logs pipeline.
 - Click on logs and navigate to patterns, this shows an aggregate of similar logs. Select the logs with the status code numbers and click on show parsing rule. The rule in Grok syntax (like regular expression) will match the logs in the pattern. More details about the parsing rules can be found in [Docs](https://docs.datadoghq.com/logs/log_configuration/parsing/?tab=matchers)

![log-pattern](img/datadog-log-pattern.jpg)

 - Navigate to [pipelines](https://app.datadoghq.com/logs/pipelines) and select create new pipeline.

 ![create-pipeline](img/datadog-create-pipeline.jpg)

 - Choose the logs to apply the parse from the filter drop down and enter a name.
 - Add a processor to the newly created pipeline.

- Choose “Grok Parser” as processor type.
- Copy and paste a sample of the logs in the “log sample”
- Copy and paste the parsing rule to the “Define parsing rules” and inspect the rule matched extraction. The parsing rule can be edited to extract specific parts of the log and exclude others. The result will be shown under the rule match extraction.

![add-processor](img/datadog-add-processor.jpg)

- Click on create to implement the parsing on incoming logs. This change will not affect existing logs.



## Notes
- For better security, store the secrets (datadog api and app key) safely in encrypted files, secret stores or Environment Variables. this module assumes the use of aws secrets manager parameter store to store the api key and app key. infromation on how to create the parameters can be found here https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-su-create.html

- While this dashboard has been designed for ecs fargate, It can also be used for ECS EC2 type and EKS by taking advantage of the AMAZON ECS and the AMAZON EKS integration metrics.

- Dashboards created on datadog can be copied in json format and replicated with this module on different datadog accounts.

