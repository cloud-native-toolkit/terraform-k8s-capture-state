
locals {
  outfile = "${var.output_path}/${var.namespace}.out"
}

resource "null_resource" "capture_state" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/capture-cluster-state.sh ${var.cluster_type} ${var.namespace} ${local.outfile} ${join(",", var.exclude_resources)}"

    environment = {
      KUBECONFIG = var.cluster_config_file_path
    }
  }
}
