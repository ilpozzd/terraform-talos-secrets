output "machine_secrets" {
  description = "Secrets to conclude a trusting relationship between virtual machines."
  value = {
    token = local.machine_token
    ca = {
      crt = base64encode(tls_self_signed_cert.machine_ca.cert_pem)
      key = base64encode(replace(tls_private_key.machine_ca.private_key_pem, "PRIVATE", "ED25519 PRIVATE"))
    }
  }
  sensitive = true
}

output "talos_admin_pki" {
  description = "Certificate and key to manage Talos virtual machines with talosctl."
  value = {
    crt = base64encode(tls_locally_signed_cert.machine_admin.cert_pem)
    key = base64encode(replace(tls_private_key.machine_admin.private_key_pem, "PRIVATE", "ED25519 PRIVATE"))
  }
  sensitive = true
}

output "cluster_secrets" {
  description = "Secrets shared between all Kubernetes nodes."
  value = {
    id     = random_id.cluster_id.b64_std
    secret = random_id.cluster_secret.b64_std
    token  = local.cluster_token
    ca = {
      crt = base64encode(tls_self_signed_cert.kubernetes_ca.cert_pem)
      key = base64encode(tls_private_key.kubernetes_ca.private_key_pem)
    }
  }
  sensitive = true
}

output "kubernetes_admin_pki" {
  description = "Cerificate and key to manage Kubernetes cluster as admininstartor."
  value = {
    crt = base64encode(tls_locally_signed_cert.kubernetes_admin.cert_pem)
    key = base64encode(tls_private_key.kubernetes_admin.private_key_pem)
  }
  sensitive = true
}

output "control_plane_cluster_secrets" {
  description = "Secrets shared between control plane Kubernetes nodes."
  value = {
    aescbcEncryptionSecret = random_id.aescbc_encryption_secret.b64_std
    aggregatorCA = {
      crt = base64encode(tls_self_signed_cert.aggregator_ca.cert_pem)
      key = base64encode(tls_private_key.aggregator_ca.private_key_pem)
    }
    serviceAccount = {
      key = base64encode(tls_private_key.kubernetes_sa.private_key_pem)
    }
    etcd = {
      ca = {
        crt = base64encode(tls_self_signed_cert.etcd_ca.cert_pem)
        key = base64encode(tls_private_key.etcd_ca.private_key_pem)
      }
    }
  }
  sensitive = true
}
