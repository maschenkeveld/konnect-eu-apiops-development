# konnect-eu-apiops-development

Terraform for the **development** APIOps environment on Kong Konnect.

## What it provisions
- Gateway control plane `apiops-development` + data-plane client certificate
- Admin team + Admin role binding
- **Developer portal** `apiops-developer-portal` (`kong/konnect-beta`) + branding (`konnect_portal_customization`)
- **connection-details** — control-plane endpoints + `portal_id` + `portal_default_domain`, written to
  **OpenBao** and/or a **local file** (see toggles)

## Prerequisites
- `terraform`, network access to `eu.api.konghq.com` (and OpenBao if `write_to_openbao=true`)
- Secrets via env: `source ./export-secrets.sh` → sets `TF_VAR_KPAT` (Konnect PAT) and
  `TF_VAR_HCV_ROOT_TOKEN` (OpenBao token). **Never commit real values.**
- Root CA cert present at `../../../ansible/roles/tls/files/root-ca-cert.pem`

## Usage
```bash
source ./export-secrets.sh
terraform init -upgrade   # -upgrade needed after provider changes
terraform plan
terraform apply
```

## Toggles (variables)
| Variable | Default | Effect |
|---|---|---|
| `write_to_openbao` | `true` | write connection-details to OpenBao `kv/konnect/konnect-eu-apiops-development/connection-details` |
| `write_to_file` | `true` | write the same JSON to `connection-details.json` (git-ignored) |
| `local_output_file` | `connection-details.json` | local filename |

## Outputs & consumers
- `terraform output`: `control_plane_endpoint`, `telemetry_endpoint`, `portal_id`, `portal_default_domain`
- **ESO** (gitops `konnect-data-plane`) reads the OpenBao `connection-details` to configure the data plane
- `portal_id` feeds the APIOps `KONNECT_PORTAL_ID` variable if you publish to the dev portal
