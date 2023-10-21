#!/usr/bin/env bash

set -o errexit
set -o pipefail

setup_env() {
  local poetry_version poetry_home

  # bashsupport disable=BP2002
  if command -v poetry &>/dev/null; then
    # bashsupport disable=BP2002
    poetry_version=$(command poetry --version | sed -E 's/.*version[[:space:]]*([0-9.]*).*/\1/g')
    echo "system-poetry-version=$poetry_version" >>"$GITHUB_OUTPUT"
    echo "POETRY_HOME=$(dirname "$(which poetry)")" >>"$GITHUB_ENV"
    echo "poetry-home=$(dirname "$(which poetry)")" >>"$GITHUB_OUTPUT"
  else
    poetry_home="${POETRY_HOME:-$HOME/.poetry}"
    echo "POETRY_HOME=$poetry_home" >>"$GITHUB_ENV"
    echo "poetry-home=$poetry_home" >>"$GITHUB_OUTPUT"
    echo "$poetry_home/bin" >>"$GITHUB_PATH"
  fi

  if [[ -f pyproject.toml ]]; then
    echo 'poetry-uses-project=true' >>"$GITHUB_OUTPUT"
  fi

  if [[ -f poetry.toml ]]; then
    echo 'poetry-uses-config=true' >>"$GITHUB_OUTPUT"
  fi

  return 0
}

__main() {
  setup_env "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  __main "$@"
fi
