module "cloudfront" {
  source             = "./modules/cloudfront"
  s3_bucket_name     = module.s3.bucket_name
  s3_bucket_domain_name = "${module.s3.bucket_name}.s3.amazonaws.com"
  tags = {
    Environment = "Dev"
    Project     = "SMC-Project"
  }
}

module "s3" {
  source             = "./modules/s3"
  bucket_name        = "smc-react-app-prabhat"
  cloudfront_oai_arn = module.cloudfront.oai_arn
  tags = {
    Environment = "Dev"
    Project     = "SMC-Project"
  }
}

module "s3" {
  source              = "./modules/s3"
  bucket_name         = var.bucket_name
  cloudfront_oai_arn  = module.cloudfront.oai_arn
  tags = {
    Environment = "Dev"
    Project     = "SMC-Project"
  }
}

module "cloudfront" {
  source      = "./modules/cloudfront"
  s3_bucket   = module.s3.bucket_name
  s3_arn      = module.s3.bucket_arn
}

module "iam" {
  source = "./modules/iam"
}

module "codebuild" {
  source = "./modules/codebuild"
  ...
}

module "codepipeline" {
  source = "./modules/codepipeline"
  ...
}
