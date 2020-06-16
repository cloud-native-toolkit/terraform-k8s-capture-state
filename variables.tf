variable "namespace" {
  type        = string
  description = "the namespace for which a snapshot should be taken"
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster (kubernetes, openshift, ocp3, or ocp4)"
}

variable "output_path" {
  type        = string
  description = "The path where the cluster state file should be written"
}

variable "cluster_config_file_path" {
  type        = string
  description = "The path and file name to the file containing the cluster configuration"
}

variable "exclude_resources" {
  type        = list(string)
  description = "A list of resources that should be excluded from the namespace snapshot"
  default     = []
}