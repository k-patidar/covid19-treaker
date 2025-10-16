variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ec2_key_name" {
  description = "EC2 Key Pair Name"
}

variable "db_password" {
  description = "RDS DB password"
  sensitive   = true
}

variable "db_username" {
  description = "RDS DB username"
  default     = "coviduser"
}

variable "db_name" {
  description = "RDS DB name"
  default     = "covidtracker"
}

variable "github_repo_url" {
  description = "HTTPS clone URL of the Git repository that EC2 will clone (e.g. https://github.com/youruser/covid-tracker.git). Leave empty to skip cloning."
  default     = ""
}
