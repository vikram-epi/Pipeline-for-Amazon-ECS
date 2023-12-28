resource "aws_iam_role" "iam-role" {
  name               = "iam-role-ECS-Execution"
  assume_role_policy = file("./iam-role.json")
}
