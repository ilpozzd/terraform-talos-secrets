# Talos OS Secrets Terraform Module

This module allows you to generate secret data (PKI, tokens, hashes) for the deployment of Talos Kubernetes Cluster. 
It is a child module of [ilpozzd/vsphere-cluster/talos](https://registry.terraform.io/modules/ilpozzd/vsphere-cluster/talos/latest). Can be used with [ilpozzd/vsphere-vm/talos](https://registry.terraform.io/modules/ilpozzd/vsphere-vm/talos/latest).
The generated secrets correspond to the configuration of [Talos OS v1.0.x](https://www.talos.dev/v1.0/)

## Usage

```hcl
module "secrets" {
  source  = "ilpozzd/secrets/talos"
  version = "1.0.0"

  validity_period_hours = 10000
}
```

## Examples

* [Terragrunt Example](https://github.com/ilpozzd/talos-vsphere-cluster-terragrunt-example)

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.1.9, < 2.0.0 |

## Providers

| Name | Version |
|---|---|
| [hashicorp/random](https://registry.terraform.io/providers/hashicorp/random/3.1.3) | 3.1.3 |
| [hashicorp/tls](https://registry.terraform.io/providers/hashicorp/tls/3.3.0) | 3.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|---|---|
| [random_string.machine_token_6bytes](https://registry.terraform.io/providers/hashicorp/random/3.1.3/docs/resources/string) | resource |
| [random_string.machine_token_16bytes](https://registry.terraform.io/providers/hashicorp/random/3.1.3/docs/resources/string) | resource |
| [tls_private_key.machine_ca](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/private_key) | resource |
| [tls_self_signed_cert.machine_ca](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/self_signed_cert) | resource |
| [tls_private_key.machine_admin](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/private_key) | resource |
| [tls_cert_request.machine_admin](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.machine_admin](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/locally_signed_cert) | resource |
| [random_id.cluster_id](https://registry.terraform.io/providers/hashicorp/random/3.1.3/docs/resources/id) | resource |
| [random_id.cluster_secret](https://registry.terraform.io/providers/hashicorp/random/3.1.3/docs/resources/id) | resource |
| [random_string.cluster_token_6bytes](https://registry.terraform.io/providers/hashicorp/random/3.1.3/docs/resources/string) | resource |
| [random_string.cluster_token_16bytes](https://registry.terraform.io/providers/hashicorp/random/3.1.3/docs/resources/string) | resource |
| [tls_private_key.kubernetes_ca](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/private_key) | resource |
| [tls_self_signed_cert.kubernetes_ca](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/self_signed_cert) | resource |
| [tls_private_key.kubernetes_admin](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/private_key) | resource |
| [tls_cert_request.kubernetes_admin](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.kubernetes_admin](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/locally_signed_cert) | resource |
| [random_id.aescbc_encryption_secret](https://registry.terraform.io/providers/hashicorp/random/3.1.3/docs/resources/id) | resource |
| [tls_private_key.aggregator_ca](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/private_key) | resource |
| [tls_private_key.kubernetes_sa](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/private_key) | resource |
| [tls_private_key.etcd_ca](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/private_key) | resource |
| [tls_self_signed_cert.etcd_ca](https://registry.terraform.io/providers/hashicorp/tls/3.3.0/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| validity_period_hours | The number of hours after initial issuing that the **ALL** certificates will become invalid. | `number` | `8760` | No |

## Outputs

| Name | Description | Type | Sensetive |
|---|---|---|---|
| machine_secrets | Secrets to conclude a trusting relationship between virtual machines. | [`object`](#machine-secrets-output) | `true` |
| talos_admin_pki | Certificate and key to manage Talos virtual machines with talosctl. | [`object`](#talos-admin-pki-output) | `true` |
| cluster_secrets | Secrets shared between all Kubernetes nodes. | [`object`](#cluster-secrets-output) | `true` |
| kubernetes_admin_pki | Cerificate and key to manage Kubernetes cluster as admininstartor | [`object`](#kubernetes-admin-pki-output) | `true` |
| control_plane_cluster_secrets | Secrets shared between control plane Kubernetes nodes | [`object`](#control-plane-cluster-secrets-output) | `true` |

### Machine Secrets Output

```hcl
{
  token = string
  ca = {
    crt = base64encode(string)
    key = base64encode(string)
  }
}
```
* `token` - The token is used by a machine to join the PKI of the cluster.
* `ca` - The root certificate authority of the PKI. It is composed of a base64 encoded `crt` and `key` in **PEM** format.

For more details see [Talos Configuration Reference (MachineConfig)](https://www.talos.dev/v1.0/reference/configuration/#machineconfig).
  
### Talos Admin PKI Output

```hcl
{
  crt = base64encode(string)
  key = base64encode(string)
}
```
The certificate authority of the PKI used in `talosconfig` to control virtual machines using `talosctl`. It is composed of a base64 encoded `crt` and `key` in **PEM** format. Signed by `machine_secrets.ca.crt`.

### Cluster Secrets Output

```hcl
{
  id     = string
  secret = string
  token  = string
  ca = {
    crt = base64encode(string)
    key = base64encode(string)
  }
}
```
* `id` - Globally unique identifier for this cluster (base64 encoded random 32 bytes).
* `secret` - Shared secret of cluster (base64 encoded random 32 bytes).
* `token` - The bootstrap token used to join the cluster.
* `ca` - The base64 encoded root certificate authority used by Kubernetes.

For more details see [Talos Configuration Reference (ClusterConfig)](https://www.talos.dev/v1.0/reference/configuration/#clusterconfig).

### Kubernetes Admin PKI Output

```hcl
{
  crt = base64encode(string)
  key = base64encode(string)
}
```

The certificate authority of the PKI to control Kubernetes cluster. It is composed of a base64 encoded `crt` with `system:masters` role and `key` in **PEM** format. Signed by `cluster_secrets.ca.crt`.

### Control Plane Cluster Secrets Output

```hcl
{
  aescbcEncryptionSecret = string
  aggregatorCA = {
    crt = base64encode(string)
    key = base64encode(string)
  }
  serviceAccount = {
    key = base64encode(string)
  }
  etcd = {
    ca = {
      crt = base64encode(string)
      key = base64encode(string)
    }
  }
}
```

* `aescbcEncryptionSecret` - The key used for the encryption of secret data at rest (base64 encoded random 32 bytes).
* `aggregatorCA` - The base64 encoded aggregator certificate authority used by Kubernetes for front-proxy certificate generation. It is composed of a base64 encoded `crt` and `key` in **PEM** format.
* `serviceAccount` - 	The base64 encoded private `key` for service account token generation.
* `etcd` - The `ca` is the root certificate authority of the etcd PKI. It is composed of a base64 encoded `crt` and `key`.

For more details see [Talos Configuration Reference (ClusterConfig)](https://www.talos.dev/v1.0/reference/configuration/#clusterconfig).

## Authors

Module is maintained by [Ilya Pozdnov](https://github.com/ilpozzd).

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.