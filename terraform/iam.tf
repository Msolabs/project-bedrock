resource "aws_iam_user" "dev" {
  name = "bedrock-dev-view"
}

resource "aws_iam_access_key" "dev_key" {
  user = aws_iam_user.dev.name
}

resource "aws_iam_user_policy_attachment" "console_ro" {
  user       = aws_iam_user.dev.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy" "s3_put" {
  name = "bedrock-dev-s3-write"
  user = aws_iam_user.dev.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = "${aws_s3_bucket.assets.arn}/*"
    }]
  })
}

# Native EKS Access Entry Mapping for K8s Role Binding
resource "aws_eks_access_entry" "dev_map" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_user.dev.arn
  type              = "STANDARD"
  kubernetes_groups = ["view"] # Safely bypasses the 404 policy bug and grants namespace read-only access
}