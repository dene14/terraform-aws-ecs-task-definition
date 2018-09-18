data "template_file" "_ulimits" {
#  depends_on = ["data.template_file._ulimit"]
  template = <<JSON
$${val}
JSON
  vars {
    val = "${join(",\n", data.template_file._ulimit.*.rendered)}"
    name = "${ lookup(var.ulimits[0], "name", "name") }"
    softlimit = "${ lookup(var.ulimits[0], "softLimit", "") }"
    hardlimit = "${ lookup(var.ulimits[0], "hardLimit") }"
  }
}

data "template_file" "_ulimit" {
  count = "${ lookup(var.ulimits[0], "name") == "__NOT_DEFINED__" ? 0 : length(var.ulimits) }"
  template = <<JSON
{
$${join(",\n", 
  compact(
    list(
    name == "" || name == "__NOT_DEFINED__" ? "" : "$${jsonencode("name")}: $${jsonencode(name)}",
    softlimit == "" || softlimit == "__NOT_DEFINED__" ? "" : "$${ jsonencode("softLimit") }: $${softlimit}",
    hardlimit == "" || hardlimit == "__NOT_DEFINED__" ? "" : "$${ jsonencode("hardLimit") }: $${hardlimit}"
    )
  )
)}
}
JSON
  vars {
    name = "${ lookup(var.ulimits[count.index], "name") }"
    softlimit = "${ lookup(var.ulimits[count.index], "softLimit", "") }"
    hardlimit = "${ lookup(var.ulimits[count.index], "hardLimit", "") }"
  }
}
