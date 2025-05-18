output "distribution_id" {
  value = aws_cloudfront_distribution.react_app_distribution.id
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.react_app_distribution.domain_name
}

output "oai_arn" {
  value = aws_cloudfront_origin_access_identity.oai.iam_arn
}
