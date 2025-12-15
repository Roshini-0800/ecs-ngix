output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}
 
output "task_definition" {
  value = aws_ecs_task_definition.nginx.family
}
 
output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}