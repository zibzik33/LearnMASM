#!/bin/bash
source ./co.sh
function get_script_dir() {
  local script_dir
  script_dir=$(realpath -- "$(dirname -- "${BASH_SOURCE[0]}")")
  echo -n "${script_dir}"
  return 0
}
function print_A_arr() {
  echo -n "$1" 
  return 0
}

# $1 == dir
function cd_unsuc() {
  co_error "The command \"cd '${1}'\" failed to execute successfully"
  exit 17
}
function cd_unsuc_return() {
  co_error "\"cd -\" == Failed to return to the previous directory [ \$OLDPWD == '${OLDPWD}' ]"
  exit 18
}
