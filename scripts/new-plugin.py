#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Create a new Neovim plugin install config file."""
import os
import sys
from argparse import ArgumentParser, Namespace
from os.path import expanduser, isdir, isfile, realpath
from re import Pattern, compile
from typing import Any, Dict, List, Tuple

TEMPLATE_PATH: str = "scripts/template.lua"
PREFIX: str = "./lua/plugin"


class ArgData:
    """Data to be passed to the argument parser."""

    args: List[str]
    kwargs: Dict[str, Any]

    def __init__(self, args: List[str], kwargs: Dict[str, Any]):
        self.args = args
        self.kwargs = kwargs


def error(*msg, sep: str = " ", end: str = "\n", flush: bool = False) -> None:
    """Print message to stderr."""
    if msg:
        print(*msg, sep=sep, end=end, flush=flush, file=sys.stderr)


def die(code: int = 0, *msg, **kwargs) -> None:
    """Exit with a given code, and print a message if supplied."""
    if msg:
        sep: str = kwargs.get("sep", " ")
        end: str = kwargs.get("end", "\n")
        flush: bool = kwargs.get("flush", False)

        func = print if code == 0 else error

        func(*msg, sep=sep, end=end, flush=flush)

    sys.exit(code)


def copy_file_to_path(path: str) -> bool:
    """Copy the template file to the specified path."""
    path = realpath(f"{PREFIX}/{path}").rstrip(".")

    pattern: Pattern[str] = compile(path)

    if not pattern.match(r".*\.lua$"):
        path += ".lua"

    try:
        with open(realpath(TEMPLATE_PATH), "r") as file:
            data = file.read()

        with open(path, "w") as file:
            file.write(data)
    except Exception:
        return False

    return True


def make_args(spec: List[ArgData]) -> Tuple[ArgumentParser, Namespace]:
    """Create the argparse parser."""
    parser = ArgumentParser(prog="new-plugin.py",
                            description="Create a new plugin configuration")

    for x in spec:
        parser.add_argument(*x.args, **x.kwargs)

    return parser, parser.parse_args()


def main() -> int:
    """Execute main workflow."""
    parser, ns = make_args([
        ArgData(args=["name"],
                kwargs={
                    "metavar": "plugin_name[.lua]",
                    "nargs": 1,
                    "type": str,
                }),
        ArgData(args=["-v", "--verbose"],
                kwargs={
                    "action": "store_true",
                    "dest": "verbose",
                    "help": "Enable verbose mode",
                    "required": False,
                }),
        ArgData(args=["-e", "--edit"],
                kwargs={
                    "action": "store_true",
                    "dest": "edit",
                    "help": "Edit the file after copying",
                    "required": False,
                })
    ])

    verbose: bool = ns.verbose
    edit: bool = ns.edit
    name: str = ns.name[0] if isinstance(ns.name, list) else ns.name

    copy_file_to_path(name)

    if edit:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
