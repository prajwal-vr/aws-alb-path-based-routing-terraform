resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "files" {
  for_each = { for file in var.files_to_upload : file.key => file }

  bucket = aws_s3_bucket.main.id
  key    = each.value.key
  source = each.value.path
  etag   = filemd5(each.value.path)
}