/**
 * Terraform module for `scheduler` Yandex Cloud function
 * Creates:
 * - two functions each for start and stop process with different set of environment variables
 * - cron triggers for start and stop
 *
 * Function supports:
 * - Instance Groups
 * - Instances
 * - Application Load Balancers
 * - Managed instance for PostgreSQL
*/

resource "yandex_resourcemanager_folder_iam_binding" "alb_editor" {
  count     = var.service_account_id == "" && contains(var.cloud_service, "alb") ? 1 : 0
  folder_id = var.folder_id
  role      = "alb.editor"
  members = [
    "serviceAccount:${local.service_acc}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "psql_editor" {
  count     = var.service_account_id == "" && contains(var.cloud_service, "psql") ? 1 : 0
  folder_id = var.folder_id
  role      = "managed-postgresql.editor"
  members = [
    "serviceAccount:${local.service_acc}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "compute_operator" {
  count     = var.service_account_id == "" && contains(var.cloud_service, "compute") ? 1 : 0
  folder_id = var.folder_id
  role      = "compute.operator"
  members = [
    "serviceAccount:${local.service_acc}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "functions_invoker" {
  count     = var.service_account_id == "" ? 1 : 0
  folder_id = var.folder_id
  role      = "serverless.functions.invoker"
  members = [
    "serviceAccount:${local.service_acc}",
  ]
}

resource "yandex_iam_service_account" "scheduler_manager" {
  count       = var.service_account_id == "" ? 1 : 0
  name        = var.function_name
  description = "Service account for scheduler"
}

locals {
  service_acc = var.service_account_id == "" ? yandex_iam_service_account.scheduler_manager[0].id : var.service_account_id
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/scheduler.py"
  output_path = "${path.module}/function.zip"
}

resource "yandex_function_trigger" "stop" {
  for_each = var.stop_cron_schedules

  name        = "${var.function_name}-${each.key}"
  description = each.value.description
  timer {
    cron_expression = each.value.cron_expression
  }

  function {
    id                 = yandex_function.stop.id
    service_account_id = local.service_acc
    retry_attempts     = 3
    retry_interval     = 10
  }

  labels = var.labels
}

resource "yandex_function" "stop" {
  name               = "${var.function_name}-stop"
  description        = var.function_description
  user_hash          = data.archive_file.this.output_base64sha256
  runtime            = var.function_runtime
  entrypoint         = "scheduler.handler"
  memory             = var.function_memory
  execution_timeout  = var.function_timeout
  service_account_id = local.service_acc

  content {
    zip_filename = data.archive_file.this.output_path
  }

  environment = {
    YS_OPERATION        = "stop"
    YS_FOLDER_ID        = var.folder_id
    YS_TAG_FILTER_KEY   = var.function_filter_key
    YS_TAG_FILTER_VALUE = var.function_filter_value
    YS_LOGGING_LEVEL    = var.logging_level
    YS_CLOUD_SERVICE    = join(", ", var.cloud_service)
  }

  labels = var.labels
}


resource "yandex_function_trigger" "start" {
  for_each = var.start_cron_schedules

  name        = "${var.function_name}-${each.key}"
  description = each.value.description
  timer {
    cron_expression = each.value.cron_expression
  }

  function {
    id                 = yandex_function.start.id
    service_account_id = local.service_acc
    retry_attempts     = 3
    retry_interval     = 10
  }

  labels = var.labels
}

resource "yandex_function" "start" {
  name               = "${var.function_name}-start"
  description        = var.function_description
  user_hash          = data.archive_file.this.output_base64sha256
  runtime            = var.function_runtime
  entrypoint         = "scheduler.handler"
  memory             = var.function_memory
  execution_timeout  = var.function_timeout
  service_account_id = local.service_acc

  content {
    zip_filename = data.archive_file.this.output_path
  }

  environment = {
    YS_OPERATION        = "start"
    YS_FOLDER_ID        = var.folder_id
    YS_TAG_FILTER_KEY   = var.function_filter_key
    YS_TAG_FILTER_VALUE = var.function_filter_value
    YS_LOGGING_LEVEL    = var.logging_level
    YS_CLOUD_SERVICE    = join(", ", var.cloud_service)
  }

  labels = var.labels
}
