
module "daily" {
  source = "https://github.com/cemeht3000/dbd159.git"

  cloud_service         = ["alb", "compute", "psql"]
  folder_id             = var.folder_id
  function_filter_key   = "Sheduler"
  function_filter_value = "daily"


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

 /*
module "weekend" {
  source = "git::https://gitlab.com/cemeht3000/dbd159.git"

  cloud_service         = ["alb", "compute", "psql"]
  folder_id             = var.folder_id
  function_filter_key   = "Sheduler"
  function_filter_value = "weekend"
  
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
  source = "git::https://gitlab.com/cemeht3000/dbd159.git"

  cloud_service         = ["alb", "compute", "psql"]
  folder_id             = var.folder_id
  function_filter_key   = "Sheduler"
  function_filter_value = "weekday"
  
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
*/