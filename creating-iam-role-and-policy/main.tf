provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_s3_bucket" "this" {
    for_each = var.bucket_suffixes
    bucket   = "${var.bucket_prefix}-${each.key}"
}

resource "aws_iam_user" "this" {
    name = var.user_name
}

resource "aws_iam_access_key" "this" {
    user = aws_iam_user.this.name
}

resource "aws_iam_policy" "example_policy" {
    name = "ExamplePolicy"
    description = "IAM policy to S3 access"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Action   = ["s3:ListBucket"]
                Resource = aws_s3_bucket.this["allowed"].arn
            },
            {
                Effect   = "Allow"
                Action   = ["s3:GetObject", "s3:PutObject"]
                Resource = "${aws_s3_bucket.this["allowed"].arn}/*"
            }
        ]
    })
}

resource "aws_iam_role" "example_role" {
    name = "ExampleRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    AWS = aws_iam_user.this.arn
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
    role = aws_iam_role.example_role.name
    policy_arn = aws_iam_policy.example_policy.arn
}

resource "aws_iam_user_policy" "assume_role" {
    name = "AllowAssumeExampleRole"
    user = aws_iam_user.this.name

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Action   = "sts:AssumeRole"
                Resource = aws_iam_role.example_role.arn
            }
        ]
    })
}