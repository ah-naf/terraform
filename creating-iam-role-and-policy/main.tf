locals {
  allowed_bucket_arn = aws_s3_bucket.this[var.allowed_bucket_suffix].arn
}

# --- S3 ---

resource "aws_s3_bucket" "this" {
  for_each = var.bucket_suffixes
  bucket   = "${var.bucket_prefix}-${each.key}"
}

# --- IAM user ---

resource "aws_iam_user" "this" {
  name = var.user_name
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

# --- IAM role: user assumes it, role reaches one bucket ---

data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.this.arn]
    }
  }
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [local.allowed_bucket_arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${local.allowed_bucket_arn}/*"]
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_policy" "s3_access" {
  name        = var.policy_name
  description = "Access to the ${var.allowed_bucket_suffix} S3 bucket only"
  policy      = data.aws_iam_policy_document.s3_access.json
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# --- IAM user permission to assume the role ---

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.this.arn]
  }
}

resource "aws_iam_user_policy" "assume_role" {
  name   = "AllowAssume-${var.role_name}"
  user   = aws_iam_user.this.name
  policy = data.aws_iam_policy_document.assume_role.json
}
