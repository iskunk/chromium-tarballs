#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# This script contains reusable functions for logging and error handling.

# Log an informational message
clog() {
    echo -e "\e[32m*\e[0m INFO: $*"
}

# Log a warning message
cwarn() {
    echo -e "\e[33m*\e[0m WARNING: $*" >&2
}

# Log an error message
cerror() {
    echo -e "\e[31m*\e[0m ERROR: $*" >&2
}

# Run a command and do not exit on failure
nonfatal() {
    "$@" || true
}

# Log an error message and exit
die() {
    eerror "$@"
    exit 1
}
