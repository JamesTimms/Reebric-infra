remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket  = "reebric-terraform-admin"
    prefix  = "terraform/state/${path_relative_to_include()}"
  }
}
