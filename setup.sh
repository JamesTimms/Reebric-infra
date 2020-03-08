#!/bin/bash

#Print commands as they are exacuted
#set -x

#Credit for this function goes to, https://gist.github.com/danisla/0a394c75bddce204688b21e28fd2fea5
function terraform_install() {
  [[ -f ${HOME}/bin/terraform ]] && echo "`${HOME}/bin/terraform version` already installed at ${HOME}/bin/terraform" && return 0
  LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep 'linux.*amd64' |tail -1)
  curl ${LATEST_URL} > /tmp/terraform.zip
  mkdir -p ${HOME}/bin
  (cd ${HOME}/bin && unzip /tmp/terraform.zip)
  if [[ -z $(grep 'export PATH=${HOME}/bin:${PATH}' ~/.bashrc) ]]; then
    echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
  fi
  
  echo "Installed: `${HOME}/bin/terraform version`"
  
  cat - << EOF 
 
Run the following to reload your PATH with terraform:
  source ~/.bashrc
EOF
}

function terragrunt_install() {
  [[ -f ${HOME}/bin/terragrunt ]] && echo "`${HOME}/bin/terragrunt version` already installed at ${HOME}/bin/terragrunt" && return 0
  terragrunt_version="v0.23.0"
  echo ${terragrunt_version}
  wget https://github.com/gruntwork-io/terragrunt/releases/download/${terragrunt_version}/terragrunt_linux_amd64 -O /tmp/terragrunt
  chmod +x /tmp/terragrunt
  mkdir -p ${HOME}/bin
  mv /tmp/terragrunt ${HOME}/bin
  if [[ -z $(grep 'export PATH=${HOME}/bin:{$PATH}' ~/.bashrc) ]]; then
    echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
  fi

  echo "Installed: $(${HOME}/bin/terragrunt | grep -A 1 'VERSION:')"

  cat - << EOF

Run the following to reload your PATH with terragrunt:
  source ~/.bashrc
EOF
}

function download_secrets() {
  gsutil cp gs://reebric-terraform-admin/terraform/secrets.auto.tfvars secrets.auto.tfvars
}

function upload_secrets() {
  gsutil cp secrets.auto.tfvars gs://reebric-terraform-admin/terraform/secrets.auto.tfvars
}

function setup_gcloud_repo() {
  sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
}

function install_prereqs() {
  yum install -y curl jq
  setup_gcloud_repo
  yum install -y google-cloud-sdk
}

function setup_gcp() {
  _IFS=$IFS
  IFS="="
  while read -r name value
  do
    export $name="$value"
  done < secrets.auto.tfvars
  IFS=$_IFS
  unset _IFS
  gcloud projects create ${TF_ADMIN} \
     --organization ${org_id} --set-as-default

  gcloud beta billing projects link ${TF_ADMIN} \
     --billing-account ${billing_account}

  gcloud iam service-accounts create terraform \
    --display-name "Terraform admin account"

  gcloud iam service-accounts keys create ${TF_CREDS} \
    --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

  gcloud projects add-iam-policy-binding ${TF_ADMIN} \
    --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
    --role roles/viewer

  gcloud projects add-iam-policy-binding ${TF_ADMIN} \
    --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
    --role roles/storage.admin

  gcloud services enable cloudresourcemanager.googleapis.com
  gcloud services enable cloudbilling.googleapis.com
  gcloud services enable iam.googleapis.com
  gcloud services enable compute.googleapis.com
  gcloud services enable serviceusage.googleapis.com

  gcloud organizations add-iam-policy-binding ${org_id} \
    --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
    --role roles/resourcemanager.projectCreator

  gcloud organizations add-iam-policy-binding ${org_id} \
    --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
    --role roles/billing.user

  gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}

  cat > backend.tf << EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_ADMIN}"
   prefix  = "terraform/state"
 }
}
EOF

  gsutil versioning set on gs://${TF_ADMIN}
}

function parse_args() {
  case "$1" in
    download)
      download_secrets
      ;;
    upload)
      upload_secrets
      ;;
    setup)
      terraform_install
      terragrunt_install
      ;;
    init)
      install_prereqs
      terraform-install
      download_secrets
      ;;
    gcp_init)
      #setup_gcp
      echo "Work in progress..."
      ;;
    *)
      echo "Usage: $0 {download|upload|setup|init|gcp_init}"
      ;;
  esac
}

parse_args $*
#set +x
