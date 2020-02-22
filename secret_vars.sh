#!/bin/bash
function download_secrets() {
  gsutil cp gs://reebric-terraform-admin/terraform/secrets.auto.tfvars secrets.auto.tfvars
}

function upload_secrets() {
  gsutil cp secrets.auto.tfvars gs://reebric-terraform-admin/terraform/secrets.auto.tfvars
}

case "$1" in
  download)
    download_secrets
    ;;
  upload)
    upload_secrets
    ;;
  *)
    echo "Usage: $0 {download|upload}"
    ;;
esac
