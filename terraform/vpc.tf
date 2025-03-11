module "vpc_dev" {
  source   = "./modules/vpc"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
  ]
}

module "vpc_prod" {
  source   = "./modules/vpc"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
    { zone = "ru-central1-b", cidr = ["10.0.2.0/24"] },
    { zone = "ru-central1-d", cidr = ["10.0.3.0/24"] },
  ]
}
