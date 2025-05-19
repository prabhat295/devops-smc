resource "aws_codebuild_project" "react_build" {
  name          = "smc-react-build"
  service_role  = var.codebuild_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    environment_variables = [
      {
        name  = "S3_BUCKET"
        value = var.s3_bucket_name
      }
    ]
  }

  source {
    type      = "GITHUB"
    location  = var.github_repo_url
    git_clone_depth = 1
    buildspec = <<EOF
version: 0.2

phases:
  install:
    commands:
      - npm install
  build:
    commands:
      - npm run build
  post_build:
    commands:
      - aws s3 sync build/ s3://$S3_BUCKET --delete
      - aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DIST_ID --paths "/*"
EOF
  }

  cache {
    type = "NO_CACHE"
  }
}
