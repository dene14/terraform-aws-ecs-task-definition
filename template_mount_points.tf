data "template_file" "_mount_points" {
#  depends_on = ["data.template_file._mount_point"]
  template = <<JSON
$${val}
JSON
  vars {
    val = "${join(",\n", data.template_file._mount_point.*.rendered)}"
#    val = ""
  }
}

data "template_file" "_mount_point" {
  count = "${ lookup(var.mount_points[0], "containerPath") == "__NOT_DEFINED__" ? 0 : lookup(var.mount_points[1], "containerPath") == "__NOT_DEFINED__" ? 1 : lookup(var.mount_points[2], "containerPath") == "__NOT_DEFINED__" ? 2 : 3 }"
  template = <<JSON
{$${join(",\n",
  compact(
    list(
    container_path == "" || container_path == "__NOT_DEFINED__" ? "" : "$${jsonencode("sourceVolume")}: $${jsonencode(source_volume)}",
    container_path == "" || container_path == "__NOT_DEFINED__" ? "" : "$${jsonencode("containerPath")}: $${jsonencode(container_path)}",
    container_path == "" || container_path == "__NOT_DEFINED__" ? "" : "$${jsonencode("readOnly")}: false"
    )
  )
)}}
JSON
  vars {
    source_volume = "${format("vol-%d", count.index + 1)}"
    container_path = "${ lookup(var.mount_points[count.index], "containerPath") }"
    read_only = "${ lookup(var.mount_points[count.index], "readOnly", "true") }"
  }
}
