#  IAM policy requirement for 3-tier web application.
# TODO: Needs to be updated to least-privilaged permissions to perform all the actions

provider "aws" {
  region = "eu-west-1"
  #   profile = "terraform-user"
}

resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"

  tags = {
    tag-key = "terraform_user"
  }
}

resource "aws_iam_access_key" "terraform_user" {
  user = aws_iam_user.terraform_user.name
}

data "aws_iam_policy_document" "terraform_user_ro" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListAllMyBuckets",
      "s3:CreateBucket",
      "s3:DeleteBucket"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "terraform_user_ro" {
  name   = "test"
  user   = aws_iam_user.terraform_user.name
  policy = data.aws_iam_policy_document.terraform_user_ro.json
}

resource "aws_iam_access_key" "terraform_user_key" {
  user = aws_iam_user.terraform_user.name
}

output "new_user_access_key" {
  value = aws_iam_access_key.terraform_user.id
}

output "new_user_secret_key" {
  value     = aws_iam_access_key.terraform_user.secret
  sensitive = true
}
