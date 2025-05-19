output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the React app"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFront distribution domain name to access the React app"
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_oai_arn" {
  description = "CloudFront Origin Access Identity ARN"
  value       = module.cloudfront.oai_arn
}

output "codepipeline_name" {
  description = "Name of the AWS CodePipeline"
  value       = module.codepipeline.pipeline_name
}
