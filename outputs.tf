output "namespace" {
  value = var.namespace
  depends_on = [null_resource.write_kubeconfig]
}

output "outfile" {
  value = local.outfile
  depends_on = [null_resource.write_kubeconfig]
}

output "cluster_type" {
  value = var.cluster_type
  depends_on = [null_resource.write_kubeconfig]
}
