#!/usr/bin/env bash
#
# Update Tree-sitter parsers
#

set -o pipefail

error() {
    local TXT=("$@")
    printf "%s\n" "${TXT[@]}" >&2
    return 0
}

_cmd() {
    [[ $# -eq 0 ]] && return 127
    while [[ $# -gt 0 ]]; do
        ! command -v "$1" &> /dev/null && return 1
        shift
    done
    return 0
}

die() {
    local EC=0
    if [[ $# -ge 1 ]] && [[ $1 =~ ^(0|-?[1-9][0-9]*)$ ]]; then
        EC="$1"
        shift
    fi

    if [[ $# -ge 1 ]]; then
        local TXT=("$@")
        if [[ $EC -eq 0 ]]; then
            printf "%s\n" "${TXT[@]}"
        else
            error "${TXT[@]}"
        fi
    fi

    exit "$EC"
}

if ! [[ -f ./.gitmodules ]] && ! [[ -d ./.git ]]; then
    die 127
fi

! _cmd 'tree-sitter' \
    'mkdir' \
    'git' \
    'basename' \
    'cp' \
    'pushd' \
    'popd' \
    && die 127

TARGET_DIR=".tree-sitter.d"

! [[ -d ./queries ]] && mkdir -p queries
! [[ -d ./"${TARGET_DIR}" ]] && mkdir -p ./"${TARGET_DIR}"
! [[ -d ./parser ]] && mkdir -p parser

_update_submodules() {
    git config -f ./.gitmodules --get-regexp '^submodule\..*\.path$' \
                                                           | while read -r PATH_KEY LOCAL_PATH; do
            [[ -d "${LOCAL_PATH}" ]] && continue
            URL_KEY="${PATH_KEY//\.path/.url}"
            URL=$(git config -f .gitmodules --get "$URL_KEY")
            git submodule add "$URL" "$LOCAL_PATH"
        done

    git submodule sync &> /dev/null
    git submodule update --init

    return 0
}

_update_submodules

for F in ./"$TARGET_DIR"/*; do
    PARSER="$(basename "$F")"
    pushd "$F" || exit 1

    tree-sitter generate &> /dev/null || true
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

    git restore --staged .
    git restore .
    git clean -df &> /dev/null || true

    popd &> /dev/null || exit 1
done

[[ -n "$(ls -A1 ./parser/*.so)" ]] && strip ./parser/*.so

exit 0
