output "container_definition" {
  value = "${data.template_file._final.rendered}"
}
