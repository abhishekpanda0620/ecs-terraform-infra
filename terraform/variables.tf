variable "vpc_name" {
    description = "AWS VPC name"
    type = string
    default = "ecs_vpc"
}

variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}
variable "tags" {
    description = "A map of tags to assign to the resource"
    type        = map(string)
    default     = {}
}

variable "ecr_repo_name" {
    description = "AWS ECR REPO NAME"
    type = string 
    default = "ecs_ecr_repo"
}