#!/usr/bin/env bash
#       _                 _
#   ___(_)_ __ ___  _ __ | | ___
#  / __| | '_ ` _ \| '_ \| |/ _ \
#  \__ \ | | | | | | |_) | |  __/
#  |___/_|_| |_| |_| .__/|_|\___|
#                  |_|
#
# Bash Boilerplate: https://github.com/alphabetum/bash-boilerplate
#
# Copyright (c) 2015 William Melody • hi@williammelody.com

set -eu
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
set -o pipefail

_print_help() {
  cat <<HEREDOC

HEREDOC
}

###############################################################################
# Program Functions
###############################################################################

_setup_full() {
  _setup_terraform
  echo "wait for resources to be up"
  sleep 10
  _setup_ansible
}

_setup_terraform() {
  printf "Setup Terraform resources\\n"
  printf "##############################################\\n"
  cd "$ANSIBLE_TF_DIR"
  terraform init
  terraform plan
  terraform apply -auto-approve 
  cd "$PROJECT_DIR"
}

_setup_ansible() {
  printf "Setup infra VPS using Ansible\\n"
  printf "##############################################\\n"
  cd "$PROJECT_DIR/ansible"
  ansible-galaxy install -r roles/requirements.yml -p roles
  ansible-playbook infras/$INFRA_NAME.yml
  cd "$PROJECT_DIR"
}

# _setup_dockerstack() {
#   printf "Setup docker stacks in swarm\\n"
#   printf "##############################################\\n"
#   cd "$PROJECT_DIR/ansible"
#   ansible-playbook playbooks/deploy_docker_stacks.yml
#   cd "$PROJECT_DIR"
# }

_destroy_infra() {
  printf "DESTROY Terraform resources\\n"
  printf "##############################################\\n"
  cd "$ANSIBLE_TF_DIR"
  terraform destroy -auto-approve
}

_main() {
  # Avoid complex option parsing when only one program option is expected.
  PROJECT_DIR=$(pwd)
  INFRA_NAME=do_k8s_manual
  ANSIBLE_TF_DIR=$PROJECT_DIR/terraform/$INFRA_NAME # variable used by ansible terraform inventory to find terraform

  if [[ "${1:-}" =~ ^-h|--help$  ]]
  then
    _print_help
  elif [[ "${1:-}" =~ ^setup_terraform$  ]]
  then
    _setup_terraform
  elif [[ "${1:-}" =~ ^setup_ansible$  ]]
  then
    _setup_ansible
  elif [[ "${1:-}" =~ ^setup_dockerstack$  ]]
  then
    _setup_dockerstack
  elif [[ "${1:-}" =~ ^destroy_infra$  ]]
  then
    _destroy_infra
  elif [[ "${1:-}" =~ ^setup_full$  ]]
  then
    _setup_full
  else
    _print_help
  fi
}

# Call `_main` after everything has been defined.
_main "$@"
