variable "name" {}

variable "cpu" { default = 10 }

variable "memory" { default = 512 }
#variable "memory_reservation" { default =  }

variable "links" {
  type = "list"
  default = []
}

variable "environment_vars" {
  type = "map"
  default = {
    "__NOT_DEFINED__" = "__NOT_DEFINED__"
  }
}

variable "log_driver" {
  default = "__NOT_DEFINED__"
}

variable "log_driver_options" {
  type = "map"
  default = {
    "__NOT_DEFINED__" = "__NOT_DEFINED__"
  }
}

variable "port_mappings" {
  type = "list"
  default = [
    {
      "hostPort" = "__NOT_DEFINED__",
      "containerPort" = "__NOT_DEFINED__",
      "protocol" = "__NOT_DEFINED__"
    }
  ]
}

variable "entrypoint" {default = ""}

variable "cmd" {default = ""}

variable "image" {default = "amazon/amazon-ecs-sample"}

variable "essential" { default = true }
