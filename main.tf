
locals {
  outfile = "${var.output_path}/${var.namespace}.out"
}

resource null_resource write_kubeconfig {
  provisioner "local-exec" {
    command = "echo -n '${var.cluster_config_file_path}' > ${path.cwd}/.kubeconfig"
  }
}

resource "null_resource" "capture_state" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/capture-cluster-state.sh ${var.cluster_type} ${var.namespace} ${local.outfile} ${join(",", var.exclude_resources)}"

    environment = {
      KUBECONFIG = var.cluster_config_file_path
    }
  }
}
