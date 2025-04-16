variable "region" {
  default = "ap-south-1"
}

variable "cluster_name" {
  default = "simple-time-cluster"
}

variable "vpc_name" {
  default = "simple-time-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "desired_capacity" {
  default = 1
}

variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 1
}

variable "instance_type" {
  default = "t3.medium"
}

variable "docker_image" {
  default = "sparshagrawal/simpletimeservice:latest"
}

variable "helm_chart_name" {
  default = "simple-time-service"
}

variable "helm_namespace" {
  default = "default"
}
