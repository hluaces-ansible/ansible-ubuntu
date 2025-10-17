#!/bin/bash
set -euo pipefail

# Validation
command -v python3 >/dev/null || { echo "Install: sudo apt install python3 python3-venv"; exit 1; }
[ -f "group_vars/all/vault_secrets.yml" ] || { echo "Configure vault secrets first"; exit 1; }

# Setup venv (uses whatever python3 is available)
[ -d venv ] || python3 -m venv venv
venv/bin/pip install -q --upgrade pip
venv/bin/pip install -q -r requirements.txt

# Install galaxy dependencies
venv/bin/ansible-galaxy role install -r roles/requirements.yml -p roles/vendors
venv/bin/ansible-galaxy collection install -r collections/requirements.yml -p collections/vendors

# Run playbook
venv/bin/ansible-playbook playbooks/ubuntu-install.yml -i inventory/prod.ini --ask-become-pass "$@"
