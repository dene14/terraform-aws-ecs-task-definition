data "template_file" "_log_configuration" {
  count = "${var.log_driver == "__NOT_DEFINED__" ? 0 : 1}"
#  depends_on = ["data.template_file._log_driver_options"]
  template = <<JSON
$${ jsonencode("logConfiguration") } : {
$${ jsonencode("logDriver") } : $${ jsonencode(log_driver) },
$${ jsonencode("options") } : {
$${ log_driver_options }
}
}
JSON
  vars {
    log_driver = "${var.log_driver}"
    log_driver_options = "${join(",\n", data.template_file._log_driver_options.*.rendered)}"
  }
}

data "template_file" "_log_driver_options" {
  count = "${ length(keys(var.log_driver_options)) }"
  template = <<JSON
$${ jsonencode(key) }: $${ jsonencode(value)}
JSON

  vars {
    key = "${ element(keys(var.log_driver_options), count.index) }"
    value = "${ lookup(var.log_driver_options, element(keys(var.log_driver_options), count.index)) }"
  }
}
