module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
  public_subnet_cidr_blocks = {
    "1" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    "2" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  }

  private_subnet_cidr_blocks = {
    "1" = {
      cidr_block        = "10.0.10.0/24"
      availability_zone = "us-east-1a"
    },
    "2" = {
      cidr_block        = "10.0.11.0/24"
      availability_zone = "us-east-1b"
    }
  }

  tags = merge(
    local.tags,
    {
      resource    = "vpc"
    }
  )

}


module "ecr" {
  source    = "./modules/ecr/"
  repo_name = var.ecr_repo_name
  tags = merge(
    local.tags,
    {
      resource = "ecr"
  })
}
