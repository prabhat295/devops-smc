resource "aws_s3_bucket" "react_app" {
  bucket = var.bucket_name
  acl    = "private"

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.react_app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cf_policy" {
  bucket = aws_s3_bucket.react_app.id
  policy = data.aws_iam_policy_document.allow_cloudfront_access.json
}

data "aws_iam_policy_document" "allow_cloudfront_access" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.react_app.arn}/*"
    ]

    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_oai_arn]
    }
  }
}
