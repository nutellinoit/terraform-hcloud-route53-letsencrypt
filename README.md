# terraform-hcloud-route53-letsencrypt
Sample terraform usage for creating a single virtual machine on Hetzner Cloud with nginx installed and one domain with let's encrypt using aws route53 dns for certification

## Usage

Rename `terraform.tfvars.example` to `terraform.tfvars`

Populate `terraform.tfvars` with real values

Then, `terraform init && terraform plan` to see if everything will be created as needed.

Execute terraform:

```bash
terraform apply
```

Ascii cast demo:

TODO