provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Youssef-shawky"
    workspaces {
      name = "scalable_application"
    }
  }
}
