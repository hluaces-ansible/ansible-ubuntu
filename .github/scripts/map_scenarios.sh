#!/usr/bin/env bash
# Maps changed file paths (stdin, one per line) to molecule scenarios.
# Usage: map_scenarios.sh <pull_request|push|schedule|fallback>
# Output: compact JSON array of scenario names ("[]" = run nothing).
set -euo pipefail

ALL=(dotfiles dropbox firefox fzf ghostty moonlander sysctl ubuntu24-desktop ubuntu24-laptop ulauncher zoxide)
FULL=(ubuntu24-desktop ubuntu24-laptop)

mode="${1:?usage: map_scenarios.sh <pull_request|push|schedule|fallback>}"

case "${mode}" in
  pull_request|push|schedule|fallback) ;;
  *)
    echo "map_scenarios.sh: unknown mode '${mode}'" >&2
    exit 2
    ;;
esac

json() {
  if [ "$#" -eq 0 ]; then
    echo '[]'
  else
    printf '%s\n' "$@" | sort -u | jq -R . | jq -sc .
  fi
}

if [ "${mode}" = "schedule" ] || [ "${mode}" = "fallback" ]; then
  json "${ALL[@]}"
  exit 0
fi

# Paths that never affect a molecule run.
mapfile -t files < <(
  grep -vE '^(\.github/|docs/|README\.md$|renovate\.json$|LICENSE$|\.gitignore$)' || true
)

if [ "${#files[@]}" -eq 0 ]; then
  json
  exit 0
fi

# Push to main: any relevant change validates the full playbook scenarios.
if [ "${mode}" = "push" ]; then
  json "${FULL[@]}"
  exit 0
fi

declare -A picked=()
for file in "${files[@]}"; do
  case "${file}" in
    molecule/common/*|collections/local/ansible_collections/hluaces/molecule/*|Makefile|requirements.txt|collections/requirements.yml|roles/requirements.yml|config/*|ansible.cfg)
      json "${ALL[@]}"
      exit 0
      ;;
    molecule/*/*)
      scenario="${file#molecule/}"
      picked["${scenario%%/*}"]=1
      ;;
    collections/local/ansible_collections/hluaces/*/roles/*/*)
      role="${file#*ansible_collections/hluaces/*/roles/}"
      role="${role%%/*}"
      case "${role}" in
        sysctl|dotfiles|dropbox|ulauncher|ghostty|fzf|zoxide|firefox|moonlander)
          picked["${role}"]=1
          ;;
        *)
          for s in "${FULL[@]}"; do picked["${s}"]=1; done
          ;;
      esac
      ;;
    *)
      for s in "${FULL[@]}"; do picked["${s}"]=1; done
      ;;
  esac
done

json "${!picked[@]}"
