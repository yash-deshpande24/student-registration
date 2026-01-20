
module "rds" {
    source = "./modules/rds"
}

module "eks" {
    source = "./modules/eks"
    project = "cbz"
    desired_nodes = 1
    max_nodes  = 1
    min_nodes  = 1
    node_instance_type = "m7i-flex.large"
}


