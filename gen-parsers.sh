#!/usr/bin/env bash
#
# Update Tree-sitter parsers
#

set -o pipefail

! [[ -f ./.gitmodules ]] && exit 1

mkdir -p parser

TARGET_DIR=".tree-sitter.d"

for F in ./"$TARGET_DIR"/*; do
    PARSER="$(basename "$F")"
    pushd "$F" || exit 1
    if tree-sitter build -o "${PARSER}.so" &> /dev/null; then
        mv "${PARSER}.so" ../../parser

        if [[ -d ./queries ]]; then
            mkdir -p "../../queries/${PARSER}"
            if [[ -d ./queries/"${PARSER}" ]]; then
                cp queries/"${PARSER}"/* "../../queries/${PARSER}"
            else
                cp queries/* "../../queries/${PARSER}"
            fi
        fi
    fi

    popd &> /dev/null || exit 1
done

exit 0
