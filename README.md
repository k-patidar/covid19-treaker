# COVID-19 Tracker

A full-stack COVID-19 stats tracker with Flask backend, PHP frontend, Postgres DB, Prometheus, Grafana, Docker Compose, Terraform AWS infra, Jenkins CI/CD.

## Local Development
1. Clone repo
2. Run: `docker-compose up --build`
3. Access:
  - Backend: http://localhost:5000/api/countries
  - Frontend: http://localhost:8081
  - Prometheus: http://localhost:9091
  - Grafana: http://localhost:3001

## Monitoring
- Prometheus scrapes backend `/metrics`.
- Grafana dashboard: import `monitoring/grafana_dashboard.json`.
- Add Prometheus as datasource in Grafana.

## Infrastructure (Terraform)
- See `infrastructure/README.md` for AWS setup.
- Edit `variables.tf` for region, keys, DB credentials.
- Run `terraform init && terraform apply`.

## Publish repository for EC2 cloning
If you want the EC2 userdata to clone this repository on boot, create a GitHub repository and push this code there.

Quick steps (PowerShell):

1. Create a GitHub repo using a token (scoped to repo creation):

```powershell
# set GITHUB_TOKEN in env first
.
\scripts\create_github_repo.ps1 -RepoName "covid-tracker" -Description "My covid tracker"
```

2. Push this project to the created repo (use the clone URL printed by the previous command). Example using your repo URL and pushing to the default `master` branch:

```powershell
.\scripts\push_initial_commit.ps1 -RemoteUrl "https://github.com/k-patidar/covid19-treaker.git" -Branch master
```

3. Update `infrastructure/variables.tf` or pass `-var 'github_repo_url=https://github.com/youruser/covid-tracker.git'` when running Terraform so EC2 user_data will clone it.

## CI/CD (Jenkins)
- See `ci/Jenkinsfile` for pipeline.
- Configure Jenkins credentials:
  - `dockerhub-user`, `dockerhub-pass` (DockerHub)
  - `aws-access-key-id`, `aws-secret-access-key` (ECR)
  - `ec2-ssh-key` (EC2 SSH)
- Jenkins will build, push, and deploy to EC2.

## Environment Variables
- All secrets/keys must be set via environment variables or Jenkins credentials.

## Error Handling
- Backend and frontend handle API errors gracefully.

## Notes
- No AWS secrets in code.
- Replace placeholders (e.g., GitHub repo, ECR repo, EC2 IP) as needed.
