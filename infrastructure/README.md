# Infrastructure Setup (Terraform)

## Prerequisites
- AWS account
- Terraform installed
- AWS credentials configured (via environment variables or ~/.aws/credentials)

## Steps
1. Edit `variables.tf` to set your region, key name, DB credentials.
2. Run:
   ```
   terraform init
   terraform plan
   terraform apply
   ```
3. EC2 instance will auto-install Docker, docker-compose, clone repo, and run stack.
4. RDS Postgres will be created and secured.

**No AWS secrets are stored in code. Use environment variables for sensitive data.**
