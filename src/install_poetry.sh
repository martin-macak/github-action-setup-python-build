#!/usr/bin/env bash

set -o errexit
set -o pipefail

install_poetry() {
  return 0
}

__main() {
  :
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  __main "$@"
fi
