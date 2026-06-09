#!/usr/bin/env bash
#
# Create new plugin from template
#

[[ $# -eq 0 ]] && exit 1

set -o pipefail

TARGET_DIR="lua/plugin"
TEMPLATE="template.lua"
F_EXT="$(echo "${TARGET}" | rev | cut -d '.' -f1 | rev)"
TARGET="$1"

[[ "$F_EXT" != "lua" ]] && TARGET+=".lua"

if [[ -f "${TARGET_DIR}/${TARGET}" ]]; then
    cp -vi "scripts/${TEMPLATE}" "${TARGET_DIR}/${TARGET}" || exit 1
else
    cp -v "scripts/${TEMPLATE}" "${TARGET_DIR}/${TARGET}" || exit 1
fi
exit 0
