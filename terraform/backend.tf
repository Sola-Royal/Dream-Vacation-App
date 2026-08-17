# S3 Remote State Backend Configuration
#
# SETUP INSTRUCTIONS:
# 1. On first run, initialize Terraform WITHOUT this backend enabled:
#    terraform init
#
# 2. Apply the infrastructure:
#    terraform apply
#
# 3. Create an S3 bucket for state management (outside Terraform, one-time setup):
#    - Bucket name pattern: terraform-state-dream-vacation-app-{account-id}
#    - Enable versioning
#    - Enable server-side encryption
#    - Block all public access
#
# 4. After the state bucket exists, uncomment the backend block below and run:
#    terraform init -migrate-state

# terraform {
#   backend "s3" {
#     bucket  = "terraform-state-dream-vacation-app-{account-id}"
#     key     = "dream-vacation-app/terraform.tfstate"
#     region  = "eu-north-1"
#     encrypt = true
#   }
# }
