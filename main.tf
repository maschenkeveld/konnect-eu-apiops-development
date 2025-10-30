terraform {
  required_providers {
    konnect = {
      source  = "kong/konnect"
      version = "2.4.1"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.0.0"
    }
  }
}

provider "konnect" {
  personal_access_token = var.KPAT
  server_url = "https://eu.api.konghq.com"
}

provider "vault" {
  address = "https://vault.pve-1.schenkeveld.io:8200"
  token   = var.HCV_ROOT_TOKEN
}

resource "konnect_gateway_control_plane" "apiops_development_gateway_control_plane" {
  name         = "apiops-development"
  cluster_type  = "CLUSTER_TYPE_CONTROL_PLANE"
  cloud_gateway = false
  auth_type     = "pki_client_certs"
  proxy_urls    = []
}

resource "konnect_gateway_data_plane_client_certificate" "apiops_development_gatewaydataplaneclientcertificate" {
  cert             = file("../../../ansible/roles/tls/files/root-ca-cert.pem")
  control_plane_id = konnect_gateway_control_plane.apiops_development_gateway_control_plane.id
}

resource "konnect_team" "apiops_development_admin_team" {
  description = "APIOps Development Admin Team"
  # labels = {
  #   key = "value"
  # }
  name = "apiops-development-admin-team"
}

resource "konnect_team_role" "apiops_development_admin_team_role" {
  entity_id        = konnect_gateway_control_plane.apiops_development_gateway_control_plane.id
  entity_region    = "eu"
  entity_type_name = "Control Planes"
  role_name        = "Admin"
  team_id          = konnect_team.apiops_development_admin_team.id
}

output "control_plane_full_output" {
  value = konnect_gateway_control_plane.apiops_development_gateway_control_plane
}

output "control_plane_endpoint" {
  value = konnect_gateway_control_plane.apiops_development_gateway_control_plane.config.control_plane_endpoint
}

output "telemetry_endpoint" {
  value = konnect_gateway_control_plane.apiops_development_gateway_control_plane.config.telemetry_endpoint
}

resource "vault_generic_secret" "konnect_endpoints" {
  path = "kv/konnect/konnect-eu-apiops-development/connection-details"

  data_json = jsonencode({
    control_plane          = replace(konnect_gateway_control_plane.apiops_development_gateway_control_plane.config.control_plane_endpoint, "https://", "")
    telemetry              = replace(konnect_gateway_control_plane.apiops_development_gateway_control_plane.config.telemetry_endpoint, "https://", "")
    control_plane_endpoint = format("%s:443", replace(konnect_gateway_control_plane.apiops_development_gateway_control_plane.config.control_plane_endpoint, "https://", ""))
    telemetry_endpoint     = format("%s:443", replace(konnect_gateway_control_plane.apiops_development_gateway_control_plane.config.telemetry_endpoint, "https://", ""))
  })
}

