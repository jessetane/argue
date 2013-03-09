#!/usr/bin/env bash
#
# test
#

source ./argue.sh

args=("$@")
if argue "-v, --version" "-h, --help" "-u, +"
then
  echo "opts: ${opts[@]}"
  echo "args: ${args[@]}"
  echo "raw: ${raw[@]}"
fi
