resource "aws_iam_role" "workernodes" {
  name = "eks-node-group-example"
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }


resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.devopsthehardway-eks.name
  node_group_name = var.eks_name
  node_role_arn  = aws_iam_role.workernodes.arn
  #vpc_ids = var.vpc_id
  subnet_ids   = [var.subnet_id_1, var.subnet_id_2, var.subnet_id_3]
  ami_type       = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
  capacity_type  = "SPOT"  # ON_DEMAND, SPOT
  disk_size      = 20
  instance_types = ["m5.large"]
  scaling_config {
   desired_size = 1
   max_size   = 3
   min_size   = 1
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

