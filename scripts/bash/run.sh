#!/bin/bash

# pre includes

function cd_unsuc() {
  co_error "The command \"cd '${1}'\" failed to execute successfully"
  exit 17
}
function cd_unsuc_return() {
  co_error "\"cd -\" == Failed to return to the previous directory [ \$OLDPWD == '${OLDPWD}' ]"
  exit 18
}

# includes #
cd core/ || cd_unsuc "core/"
shellcheck_is_trash=1; if [[ ${shellcheck_is_trash} == 0 ]]; then
  source core/dependencies.sh
fi
source ./dependencies.sh
cd - > /dev/null || cd_unsuc_return
# -------- #


cd "$(dep_get_path "build_dir")" || cd_unsuc "$(dep_get_path "build_dir")"
./main.exe
cd - > /dev/null || cd_unsuc_return
