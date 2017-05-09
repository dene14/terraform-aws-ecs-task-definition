data "template_file" "_environment_vars" {
  count = "${lookup(var.environment_vars, "__NOT_DEFINED__", "__ITS_DEFINED__") == "__NOT_DEFINED__" ? 0 : 1}"
  depends_on = ["data.template_file._environment_var"]
  template = <<JSON
$${ jsonencode("environment") } : [
$${val}
]
JSON
  vars {
    val = "${join(",\n", data.template_file._environment_var.*.rendered)}"
  }
}

data "template_file" "_environment_var" {
  count = "${ length(keys(var.environment_vars)) }"
  template = <<JSON
{
$${join(",\n", 
  compact(
    list(
    var_name == "__NOT_DEFINED__" ? "" : "$${ jsonencode("name") }: $${ jsonencode(var_name)}",
    var_value == "__NOT_DEFINED__" ? "" : "$${ jsonencode("value") }: $${ jsonencode(var_value)}"
    )
  )
)}
}
JSON

  vars {
    var_name = "${ element(sort(keys(var.environment_vars)), count.index) }"
    var_value = "${  lookup(var.environment_vars, element(sort(keys(var.environment_vars)), count.index), "") }"
  }
}
