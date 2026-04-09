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

function resolve_specific_paths() {
  dep_constants_assembly_json=$(dep_get_path "assembly_json")
  jq empty "${dep_constants_assembly_json}"
  jq_exit_code=$?
  if [[ ${jq_exit_code} -ne 0 ]]; then
    co_error "JSON is invalid! [${dep_constants_assembly_json}]"
    exit 5
  fi
  if [[ $(jq '.paths.ml64' ${dep_constants_assembly_json}) == "null" ]]; then
    co_error ".paths.ml64 field not found"
    exit 6
  fi
  dep_constants_ml64=$(jq -r ".paths.ml64" "${dep_constants_assembly_json}")
  dep_add_path "ml64" "${dep_constants_ml64}" "true"
  dep_constants_src_dir=$(dep_get_path "src_dir")
}

resolve_specific_paths

echo "wine $(dep_get_path ml64) ${dep_constants_src_dir}/main.asm /link /entry:main"

wine '$(dep_get_path "ml64")' "${dep_constants_src_dir}/main.asm /link /entry:main"
