#!/bin/bash

#Print commands as they are exacuted
set -x

#Credit for this function goes to, https://gist.github.com/danisla/0a394c75bddce204688b21e28fd2fea5
function terraform-install() {
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

#!/bin/bash
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

function parse_args() {
  case "$1" in
    download)
      download_secrets
      ;;
    upload)
      upload_secrets
      ;;
    setup)
      terraform-install
      ;;
    init)
      install_prereqs
      terraform-install
      download_secrets
      ;;
    *)
      echo "Usage: $0 {download|upload|setup|init}"
      ;;
  esac
}

parse_args $*
set +x
