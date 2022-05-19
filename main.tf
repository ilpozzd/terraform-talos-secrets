terraform {
  required_version = ">= 1.1.9"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.1.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.3.0"
    }
  }
}

# Machine token
resource "random_string" "machine_token_6bytes" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "machine_token_16bytes" {
  length  = 16
  special = false
  upper   = false
}

# Machine CA certificate
resource "tls_private_key" "machine_ca" {
  algorithm = "ED25519"
}

resource "tls_self_signed_cert" "machine_ca" {
  private_key_pem = tls_private_key.machine_ca.private_key_pem

  subject {
    organization = "talos"
  }

  is_ca_certificate     = true
  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

# Talos admin certificate
resource "tls_private_key" "machine_admin" {
  algorithm = "ED25519"
}

resource "tls_cert_request" "machine_admin" {
  private_key_pem = tls_private_key.machine_admin.private_key_pem

  subject {
    organization = "os:admin"
  }
}

resource "tls_locally_signed_cert" "machine_admin" {
  cert_request_pem   = tls_cert_request.machine_admin.cert_request_pem
  ca_private_key_pem = tls_private_key.machine_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.machine_ca.cert_pem

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

# Cluster ID
resource "random_id" "cluster_id" {
  byte_length = 32
}

# Cluster secret
resource "random_id" "cluster_secret" {
  byte_length = 32
}

# Kubernetes bootstrap token
resource "random_string" "cluster_token_6bytes" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "cluster_token_16bytes" {
  length  = 16
  special = false
  upper   = false
}

# Kubernetes root CA certificate
resource "tls_private_key" "kubernetes_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "kubernetes_ca" {
  private_key_pem = tls_private_key.kubernetes_ca.private_key_pem

  subject {
    organization = "kubernetes"
  }

  is_ca_certificate     = true
  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

# Kubernetes admin certificate
resource "tls_private_key" "kubernetes_admin" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "kubernetes_admin" {
  private_key_pem = tls_private_key.kubernetes_admin.private_key_pem

  subject {
    organization = "system:masters"
    common_name  = "admin"
  }
}

resource "tls_locally_signed_cert" "kubernetes_admin" {
  cert_request_pem   = tls_cert_request.kubernetes_admin.cert_request_pem
  ca_private_key_pem = tls_private_key.kubernetes_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.kubernetes_ca.cert_pem

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "client_auth"
  ]
}

# AESCBC Encryption secret
resource "random_id" "aescbc_encryption_secret" {
  byte_length = 32
}

# Generate aggregator CA certificate
resource "tls_private_key" "aggregator_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "aggregator_ca" {
  private_key_pem = tls_private_key.aggregator_ca.private_key_pem

  subject {
    organization = "front-proxy"
  }

  is_ca_certificate     = true
  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

# ServiceAccount key
resource "tls_private_key" "kubernetes_sa" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# etcd CA certificate
resource "tls_private_key" "etcd_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "etcd_ca" {
  private_key_pem = tls_private_key.etcd_ca.private_key_pem

  subject {
    organization = "etcd"
  }

  is_ca_certificate     = true
  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}
