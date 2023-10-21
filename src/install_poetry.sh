#!/usr/bin/env bash

set -o errexit
set -o pipefail

install_poetry() {
  return 0
}

__main() {
  :
  if [ -z "$POETRY_HOME" ]; then
    echo >&2 'POETRY_HOME is not set'
    return 1
  fi

  if [ $# -gt 0 ]; then
    local version
    version="$1"
    shift
  else
    version='latest'
  fi

  local temp_dir
  temp_dir="$(mktemp -d)"

  local install_script
  install_script="${temp_dir}/install.sh"

  curl -sSL https://install.python-poetry.org/ --output "$install_script"

  if [ "$version" == 'latest' ]; then
    python3 "$install_script" --yes
  else
    python3 "$install_script" --yes --version "$version"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  __main "$@"
  exit $?
fi
