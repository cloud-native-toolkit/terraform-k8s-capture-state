
locals {
  outfile = "${var.output_path}/${var.namespace}.out"
}

resource null_resource write_kubeconfig {
  provisioner "local-exec" {
    command = "echo -n '${var.cluster_config_file_path}' > ${path.cwd}/.kubeconfig"
  }
}
