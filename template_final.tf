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
        "${jsonencode("memory")}: ${var.memory}",
        "${jsonencode("entryPoint")}: ${jsonencode(compact(split(" ", var.entrypoint)))}",
        "${jsonencode("command")}: ${jsonencode(compact(split(" ", var.cmd)))}",
        "${jsonencode("links")}: ${jsonencode(var.links)}",
        "${jsonencode("portMappings")}: [${data.template_file._port_mappings.rendered}]",
        "${join("", data.template_file._environment_vars.*.rendered)}",
        "${join("", data.template_file._log_configuration.*.rendered)}",
        "${jsonencode("name")}: ${jsonencode(var.name)}",
        "${jsonencode("image")}: ${jsonencode(var.image)}",
        "${jsonencode("essential")}: ${var.essential ? true : false }",
        ))
    )}"
}
}
