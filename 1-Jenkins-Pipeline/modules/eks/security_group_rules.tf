# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/eks/security_group_rules.tf

# Allow communication between worker nodes and the control plane on port 443
resource "aws_security_group_rule" "allow_worker_to_control_plane" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker.id
  security_group_id        = aws_security_group.cluster.id

  depends_on = [aws_security_group.worker, aws_security_group.cluster]
}

# Allow control plane to communicate with worker nodes on port 10250
resource "aws_security_group_rule" "allow_control_plane_to_worker" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.worker.id

  depends_on = [aws_security_group.worker, aws_security_group.cluster]
}
