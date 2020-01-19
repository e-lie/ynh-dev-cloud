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
  _setup_ansible
  _setup_dockerstack
}

_setup_terraform() {
  printf "Setup Terraform resources\\n"
  printf "##############################################\\n"
  cd "$PROJECT_DIR/$ANSIBLE_TF_DIR"
  terraform init
  terraform plan
  terraform apply -auto-approve 
  cd "$PROJECT_DIR"
}

_destroy_infra() {
  printf "DESTROY Terraform resources\\n"
  printf "##############################################\\n"
  cd "$PROJECT_DIR/$ANSIBLE_TF_DIR"
  terraform destroy -auto-approve
}

_main() {
  # Avoid complex option parsing when only one program option is expected.
  PROJECT_DIR=$(pwd)
  ANSIBLE_TF_DIR=terraform/do_k8s_managed/


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
