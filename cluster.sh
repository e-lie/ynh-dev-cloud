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
}

_setup_terraform() {
  printf "Setup Terraform resources\\n"
  printf "##############################################\\n"
  source .env
  cd "$PROJECT_DIR/terraform"
  terraform init
  terraform plan
  terraform apply -auto-approve 
}

_setup_ansible() {
  printf "Setup infra VPS using Ansible\\n"
  printf "##############################################\\n"
  source .env
  cd "$PROJECT_DIR/ansible"
  ansible-galaxy install -r roles/requirements.yml -p roles
  ansible-playbook site_setup.yml
}

_setup_dockerstack() {
  printf "Perform a simple operation.\\n"
}

_main() {
  # Avoid complex option parsing when only one program option is expected.
  PROJECT_DIR=$(pwd)

  if [[ "${1:-}" =~ ^-h|--help$  ]]
  then
    _print_help
  elif [[ "${1:-}" =~ ^setup_terraform$  ]]
  then
    _setup_terraform
  elif [[ "${1:-}" =~ ^setup_ansible$  ]]
  then
    _setup_ansible
  else
    _print_help
  fi
}

# Call `_main` after everything has been defined.
_main "$@"
