resource "aws_ecr_repository" "ecs_ecr_repo" {
  name                 = var.repo_name
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags                 = merge(var.tags, { Name = var.repo_name })
  
}