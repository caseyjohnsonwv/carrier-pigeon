resource "aws_s3_bucket" "frontend" {
  # create cors-enabled s3 bucket for frontend code to live in
  bucket        = "playlist-pigeon-frontend-bucket-${var.env_name}"
  force_destroy = true
}

resource "aws_s3_bucket_cors_configuration" "frontend" {
  # add cors config to frontend bucket
  bucket = aws_s3_bucket.frontend.bucket

  cors_rule {
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket" "playlists" {
  # create s3 bucket for conversion jobs' output jsons
  bucket        = "playlist-pigeon-playlist-bucket-${var.env_name}"
  force_destroy = true
}