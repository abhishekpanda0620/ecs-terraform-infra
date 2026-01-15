variable "vpc_name" {
    description = "The name of the VPC"
    type        = string
    default = "ecs_vpc"
}

variable "tags" {
    description = "A map of tags to assign to the resource"
    type        = map(string)
    default     = {}
}
variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = ""
}
variable "public_subnet_cidr_blocks" {
  description = "A map of public subnet configurations"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {}
}

variable "private_subnet_cidr_blocks" {
  description = "A map of private subnet configurations"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {}
}

variable "availability_zones" {
    description = "A list of availability zones for the subnets"
    type        = list(string)
    default     = []
}

