# Generate random suffix for bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Daily Reports S3 Bucket
resource "aws_s3_bucket" "daily_reports" {
  bucket = "daily-reports-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "daily-reports"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "daily_reports_block" {
  bucket = aws_s3_bucket.daily_reports.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}