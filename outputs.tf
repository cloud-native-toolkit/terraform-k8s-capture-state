output "namespace" {
  value = var.namespace
  depends_on = [null_resource.capture_state]
}

output "outfile" {
  value = local.outfile
  depends_on = [null_resource.capture_state]
}
