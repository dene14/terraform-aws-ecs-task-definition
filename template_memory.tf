data "template_file" "_memory_allocation" {
  template = <<JSON
$${join(",\n", 
  compact(
    list(
    "$${ jsonencode("memory") }: $${memory}",
    memory_reservation == "__NOT_DEFINED__" ? "" : "$${jsonencode("memoryReservation")}: $${memory_reservation}",
    )
  )
)}
JSON
  vars {
    memory = "${ var.memory }"
    memory_reservation = "${ var.memory_reservation }"
  }
}
