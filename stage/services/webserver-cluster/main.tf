provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-state-nuk"
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-west-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  ami         = "ami-0943382e114f188e8"
  server_text = "New server text v3"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-nuk"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
  custom_tags = {
    Owner      = "team-foo"
    DeployedBy = "terraform"
  }
}
