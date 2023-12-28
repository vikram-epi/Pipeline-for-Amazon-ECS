resource "aws_iam_role_policy" "iam-policy" {
  name   = "AWS-ECS-Execution-Role"
  role   = aws_iam_role.iam-role.id
  policy = file("iam-policy.json")
}
