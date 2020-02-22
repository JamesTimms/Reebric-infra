#!/bin/bash
#Terraform variables
export TF_ADMIN=reebric-terraform-admin
export TF_CREDS=~/.config/gcloud/${TF_ADMIN}-terraform-admin.json

#GCP authentication details.
export GOOGLE_CLOUD_KEYFILE_JSON=${TF_CREDS}
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}
