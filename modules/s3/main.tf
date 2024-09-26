resource "aws_s3_bucket" "source" {
  bucket = "${var.name}-source"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "${var.name}-source"
  }
}

resource "aws_s3_bucket" "destination" {
  bucket = "${var.name}-destination"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "${var.name}-destination"
  }
}

resource "aws_iam_role" "s3_replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "s3.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_replication_policy" {
  role = aws_iam_role.s3_replication_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ]
      Resource = "${aws_s3_bucket.source.arn}/*"
    },
    {
      Effect = "Allow"
      Action = [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ]
      Resource = "${aws_s3_bucket.destination.arn}/*"
    }]
  })
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  role = aws_iam_role.s3_replication_role.arn
  bucket = aws_s3_bucket.source.bucket

  rule {
    id = "replication-rule"
    status = "Enabled"

    filter {
      prefix = ""  # Replicate all objects
    }

    destination {
      bucket = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}
