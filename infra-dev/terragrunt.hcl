# Include dynamic config for backend state from parent terragrunt.hcl
include {
  path = find_in_parent_folders()
}
