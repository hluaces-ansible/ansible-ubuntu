#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

fail=0
check() {
  local desc="$1" expected="$2" actual="$3"
  if [ "${expected}" = "${actual}" ]; then
    echo "ok: ${desc}"
  else
    echo "FAIL: ${desc}: expected ${expected} got ${actual}"
    fail=1
  fi
}

ALL='["dotfiles","dropbox","ghostty","sysctl","ubuntu24-desktop","ubuntu24-laptop","ulauncher"]'
FULL='["ubuntu24-desktop","ubuntu24-laptop"]'

check "schedule runs all" "${ALL}" "$(./map_scenarios.sh schedule < /dev/null)"
check "fallback runs all" "${ALL}" "$(./map_scenarios.sh fallback < /dev/null)"
check "push: relevant file -> full" "${FULL}" \
  "$(echo 'playbooks/ubuntu-install.yml' | ./map_scenarios.sh push)"
check "push: CI-only change -> nothing" "[]" \
  "$(echo '.github/workflows/lint.yml' | ./map_scenarios.sh push)"
check "PR: single role -> its scenario" '["dotfiles"]' \
  "$(echo 'collections/local/ansible_collections/hluaces/iac/roles/dotfiles/tasks/main.yml' | ./map_scenarios.sh pull_request)"
check "PR: ubuntu collection role -> its scenario" '["ghostty"]' \
  "$(echo 'collections/local/ansible_collections/hluaces/ubuntu/roles/ghostty/tasks/main.yml' | ./map_scenarios.sh pull_request)"
check "PR: scenario dir -> that scenario" '["sysctl"]' \
  "$(echo 'molecule/sysctl/converge.yml' | ./map_scenarios.sh pull_request)"
check "PR: playbook -> full" "${FULL}" \
  "$(echo 'playbooks/ubuntu-install.yml' | ./map_scenarios.sh pull_request)"
check "PR: harness -> all" "${ALL}" \
  "$(echo 'molecule/common/namespace.yml' | ./map_scenarios.sh pull_request)"
check "PR: docs only -> nothing" "[]" \
  "$(printf 'README.md\n.gitignore\n' | ./map_scenarios.sh pull_request)"
check "PR: role for unscenarioed area -> full" "${FULL}" \
  "$(echo 'roles/local/awscli/tasks/main.yml' | ./map_scenarios.sh pull_request)"
check "PR: role + host_vars -> role scenario + full" \
  '["dotfiles","ubuntu24-desktop","ubuntu24-laptop"]' \
  "$(printf 'collections/local/ansible_collections/hluaces/iac/roles/dotfiles/tasks/main.yml\ninventory/host_vars/ubuntu24-desktop/vars.yml\n' | ./map_scenarios.sh pull_request)"

if ./map_scenarios.sh bogus_mode < /dev/null 2> /dev/null; then
  echo "FAIL: unknown mode accepted"
  fail=1
else
  echo "ok: unknown mode rejected"
fi

exit "${fail}"
