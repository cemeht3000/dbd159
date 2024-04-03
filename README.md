<!-- BEGIN_TF_DOCS -->
Terraform module for `scheduler` Yandex Cloud function
Creates:
- two functions each for start and stop process with different set of environment variables
- cron triggers for start and stop

Function supports:
- Instance Groups
- Instances
- Application Load Balancers
- Managed instance for PostgreSQL

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.2.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | ~> 0.105 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.2.0 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | ~> 0.105 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_function.start](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/function) | resource |
| [yandex_function.stop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/function) | resource |
| [yandex_function_trigger.start](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/function_trigger) | resource |
| [yandex_function_trigger.stop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/function_trigger) | resource |
| [yandex_iam_service_account.scheduler_manager](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_resourcemanager_folder_iam_binding.alb_editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [yandex_resourcemanager_folder_iam_binding.compute_operator](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [yandex_resourcemanager_folder_iam_binding.functions_invoker](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [yandex_resourcemanager_folder_iam_binding.psql_editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_service"></a> [cloud\_service](#input\_cloud\_service) | Type of Yandex Cloud service, choose from list: alb, compute, psql | `list(any)` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID | `string` | n/a | yes |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Function description | `string` | `"Функция для управления расписанием сервисов"` | no |
| <a name="input_function_filter_key"></a> [function\_filter\_key](#input\_function\_filter\_key) | Tag key to filter resources | `string` | n/a | yes |
| <a name="input_function_filter_value"></a> [function\_filter\_value](#input\_function\_filter\_value) | Tag value to filter resources | `string` | n/a | yes |
| <a name="input_function_memory"></a> [function\_memory](#input\_function\_memory) | Function memory | `number` | `128` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Function name | `string` | `"scheduler"` | no |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | Function runtime | `string` | `"python38"` | no |
| <a name="input_function_timeout"></a> [function\_timeout](#input\_function\_timeout) | Function timeout | `number` | `10` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels | `map(string)` | `null` | no |
| <a name="input_logging_level"></a> [logging\_level](#input\_logging\_level) | Function logging level | `string` | `"INFO"` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Service account ID for the function | `string` | `""` | no |
| <a name="input_start_cron_schedules"></a> [start\_cron\_schedules](#input\_start\_cron\_schedules) | List of start triggers to create | <pre>map(object({<br>    description     = string<br>    cron_expression = string<br>  }))</pre> | n/a | yes |
| <a name="input_stop_cron_schedules"></a> [stop\_cron\_schedules](#input\_stop\_cron\_schedules) | List of stop triggers to create | <pre>map(object({<br>    description     = string<br>    cron_expression = string<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->