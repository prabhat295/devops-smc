variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "github_oauth_token" {
  type = string
  description = "GitHub OAuth token for CodePipeline source integration"
}
