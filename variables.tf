variable "start_cron_schedules" {
  type = map(object({
    description     = string
    cron_expression = string
  }))
  description = "List of start triggers to create"
}

variable "stop_cron_schedules" {
  type = map(object({
    description     = string
    cron_expression = string
  }))
  description = "List of stop triggers to create"
}

variable "labels" {
  type        = map(string)
  description = "Labels"
  default     = null
}

variable "service_account_id" {
  type        = string
  description = "Service account ID for the function"
  default     = ""
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
}

variable "function_name" {
  type        = string
  description = "Function name"
  default     = "scheduler"
}

variable "function_description" {
  type        = string
  description = "Function description"
  default     = "Функция для управления расписанием сервисов"
}

variable "function_runtime" {
  type        = string
  description = "Function runtime"
  default     = "python38"
}

variable "function_memory" {
  type        = number
  description = "Function memory"
  default     = 128
}

variable "function_timeout" {
  type        = number
  description = "Function timeout"
  default     = 10
}

variable "function_filter_key" {
  type        = string
  description = "Tag key to filter resources"
}

variable "function_filter_value" {
  type        = string
  description = "Tag value to filter resources"
}

variable "cloud_service" {
  type        = list(any)
  description = "Type of Yandex Cloud service, choose from list: alb, compute, psql"
}

variable "logging_level" {
  type        = string
  description = "Function logging level"
  default     = "INFO"
}
