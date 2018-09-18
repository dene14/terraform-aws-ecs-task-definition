data "template_file" "_final" {
#  depends_on = [
#    "data.template_file._environment_vars",
#    "data.template_file._port_mappings",
#    "data.template_file._log_configuration",
#  ]
template = <<JSON
{
  $${val}
}
JSON
vars {
  val = "${join(",\n    ",
      compact(list(
        "${jsonencode("cpu")}: ${var.cpu}",
        "${data.template_file._memory_allocation.rendered}",
        "${jsonencode("entryPoint")}: ${jsonencode(compact(split(" ", var.entrypoint)))}",
        "${jsonencode("command")}: ${jsonencode(var.cmd)}",
        "${jsonencode("links")}: ${jsonencode(var.links)}",
        "${jsonencode("portMappings")}: [${data.template_file._port_mappings.rendered}]",
        "${jsonencode("mountPoints")}: [${data.template_file._mount_points.rendered}]",
        "${join("", data.template_file._environment_vars.*.rendered)}",
        "${join("", data.template_file._log_configuration.*.rendered)}",
        "${jsonencode("ulimits")}: [${data.template_file._ulimits.rendered}]",
        "${jsonencode("name")}: ${jsonencode(var.name)}",
        "${jsonencode("image")}: ${jsonencode(var.image)}",
        "${jsonencode("essential")}: ${var.essential ? true : false }",
        ))
    )}"
}
}
