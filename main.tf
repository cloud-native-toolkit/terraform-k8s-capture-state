
locals {
  outfile = "${var.output_path}/${var.namespace}.out"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"

  clis = ["helm", "kubectl"]
}

resource "null_resource" "capture_state" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/capture-cluster-state.sh ${var.cluster_type} ${var.namespace} ${local.outfile} ${join(",", var.exclude_resources)}"

    environment = {
      BIN_DIR = module.setup_clis.bin_dir
      KUBECONFIG = var.cluster_config_file_path
    }
  }
}