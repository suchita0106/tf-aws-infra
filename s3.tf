# resource "aws_s3_bucket" "file_storage" {
#   bucket        = "file-storage-${random_uuid.generated_id.result}"
#   force_destroy = true
# }

resource "aws_s3_bucket" "file_storage" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "file_storage_lifecycle" {
  bucket = aws_s3_bucket.file_storage.id

  rule {
    id     = "lifecycle-rule-1"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  depends_on = [
    aws_s3_bucket.file_storage
  ]
}

resource "aws_s3_bucket_ownership_controls" "ownership_rule" {
  bucket = aws_s3_bucket.file_storage.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "file_storage_public_access_block" {
  bucket                  = aws_s3_bucket.file_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# sse_algorithm = "aws:kms" specifies the use of KMS for encryption.
# kms_master_key_id = aws_kms_key.s3_key.arn links the custom KMS key created for S3.

# File: s3.tf
resource "aws_s3_bucket_server_side_encryption_configuration" "file_storage_encryption" {
  bucket = aws_s3_bucket.file_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}


resource "random_uuid" "generated_id" {}
