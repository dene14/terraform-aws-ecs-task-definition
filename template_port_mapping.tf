data "template_file" "_port_mappings" {
#  depends_on = ["data.template_file._port_mapping"]
  template = <<JSON
$${val}
JSON
#host_port == "__NOT_DEFINED__" && container_port == "__NOT_DEFINED__" && protocol == "__NOT_DEFINED__" ? $${ jsonencode([])} : $${val}
  vars {
    val = "${join(",\n", data.template_file._port_mapping.*.rendered)}"
    host_port = "${ lookup(var.port_mappings[0], "hostPort", "") }"
    container_port = "${ lookup(var.port_mappings[0], "containerPort") }"
    protocol = "${ lookup(var.port_mappings[0], "protocol", "") }"
  }
}

data "template_file" "_port_mapping" {
  count = "${ lookup(var.port_mappings[0], "containerPort") == "__NOT_DEFINED__" ? 0 : length(var.port_mappings) }"
  template = <<JSON
{
$${join(",\n", 
  compact(
    list(
    host_port == "" || host_port == "__NOT_DEFINED__" ? "" : "$${ jsonencode("hostPort") }: $${host_port}",
    container_port == "" || container_port == "__NOT_DEFINED__" ? "" : "$${jsonencode("containerPort")}: $${container_port}",
    protocol == "" || protocol == "__NOT_DEFINED__" ? "" : "$${ jsonencode("protocol") }: $${jsonencode(protocol)}"
    )
  )
)}
}
JSON
  vars {
    host_port = "${ lookup(var.port_mappings[count.index], "hostPort", "") }"
    container_port = "${ lookup(var.port_mappings[count.index], "containerPort") }"
    protocol = "${ lookup(var.port_mappings[count.index], "protocol", "") }"
  }
}
