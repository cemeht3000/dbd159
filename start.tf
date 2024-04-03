
module "daily" {
  source = "../"

  cloud_service         = ["alb", "compute", "psql"]
  folder_id             = var.folder_id
  function_filter_key   = "daily"
  function_filter_value = "text"
  service_account_id    = local.service_acc
  
  #key = function_filter_key == "daily" ? 

  start_cron_schedules = {
    start = {
      cron_expression = "0 10 * * *"
      description     = "value"
    }
  }

  stop_cron_schedules = {
    stop = {
      cron_expression = "0 20 * * *"
      description     = "value"
    }
  }
}

module "weekend" {
  source = "../"

  folder_id             = var.folder_id
  function_filter_key   = "weekend"
  function_filter_value = "text"
  service_account_id    = local.service_acc
  function_name         = "scheduler-sa-yes"
  cloud_service         = ["alb", "compute"]

  start_cron_schedules = {
    start = {
      cron_expression = "0 10 * * 1"
      description     = "value"
    }
  }

  stop_cron_schedules = {
    stop = {
      cron_expression = "0 20 * * 5"
      description     = "value"
    }
  }
}

module "weekday" {
  source = "../"

  folder_id             = var.folder_id
  function_filter_key   = "weekday"
  function_filter_value = "text"
  service_account_id    = local.service_acc
  function_name         = "scheduler-sa-yes"
  cloud_service         = ["alb", "compute"]

  start_cron_schedules = {
    start = {
      cron_expression = "0 10 * * 1-5"
      description     = "value"
    }
  }

  stop_cron_schedules = {
    stop = {
      cron_expression = "0 20 * * 1-5"
      description     = "value"
    }
  }
}