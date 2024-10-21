
resource "aws_iam_role" "this" {
  name                = "ryanh-github-oidc-role-test"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                    "token.actions.githubusercontent.com:sub": [
                        "repo:ryan-hoofard/github-aws-oidc-terraform:environment:${var.environment}:job_workflow_ref:ryan-hoofard/github-aws-oidc-terraform/.github/workflows/reusable-terraform-workflow.yml@refs/heads/dev",
                        "repo:ryan-hoofard/new-repo:environment:${var.environment}"
                    ]
                }
            }
        }
    ]
})
  managed_policy_arns = [data.aws_iam_policy.this.arn]
}

data "aws_iam_policy" "this" {
  name = "AmazonS3FullAccess"
}

data "aws_caller_identity" "current" {}
