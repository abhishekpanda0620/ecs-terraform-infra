output "vpc_id"{
    value = module.vpc.vpc_id
}
output "ecr_repo_url" {
    value = module.ecr.repo_url
}