#!/usr/bin/env bash
#
# Update Tree-sitter parsers
#

set -o pipefail

! [[ -f ./.gitmodules ]] && exit 1

TARGET_DIR=".tree-sitter.d"

if ! [[ -d ./"${TARGET_DIR}" ]]; then
    mkdir -p ./"${TARGET_DIR}"
fi

git config -f .gitmodules --get-regexp '^submodule\..*\.path$' \
                                                           | while read -r PATH_KEY LOCAL_PATH; do
        [[ -d "${LOCAL_PATH}" ]] && continue
        URL_KEY=$(echo "$PATH_KEY" | sed 's/\.path/.url/')
        URL=$(git config -f .gitmodules --get "$URL_KEY")
        git submodule add "$URL" "$LOCAL_PATH"
    done

mkdir -p parser
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
