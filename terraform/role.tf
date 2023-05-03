resource "aws_iam_instance_profile" "s3_readonly" {
  name = "profile_for_s3_readonly"
  role = aws_iam_role.readonly_role.name
}

resource "aws_iam_role" "readonly_role" {
  name = "readonly_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
  }
}

resource "aws_iam_role_policy_attachment" "readonly_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.readonly_role.name
}