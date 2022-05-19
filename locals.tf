locals {
  machine_token = "${random_string.machine_token_6bytes.result}.${random_string.machine_token_16bytes.result}"
  cluster_token = "${random_string.cluster_token_6bytes.result}.${random_string.cluster_token_16bytes.result}"
}
