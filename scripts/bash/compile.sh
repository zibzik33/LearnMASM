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
  # if [[ $(jq '.paths.ml64' ${dep_constants_assembly_json}) == "null" ]]; then
  #   co_error ".paths.ml64 field not found"
  #   exit 6
  # fi
  dep_constants_ml64=$(jq -r ".paths.ml64" "${dep_constants_assembly_json}")
  dep_add_path "ml64" "${dep_constants_ml64}" "true"
  dep_constants_linker=$(jq -r ".paths.linker" "${dep_constants_assembly_json}")
  dep_add_path "linker" "${dep_constants_linker}" "true"


  dep_constants_libs_dir="$(jq -r ".libs.main_dir_path" "${dep_constants_assembly_json}")"
  dep_add_path "libs_dir" "${dep_constants_libs_dir}" "true"

  dep_constants_build_dir="$(dep_get_path "build_dir")"
  dep_constants_src_dir="$(dep_get_path "src_dir")"
}

# $1 == file name (main.asm)
function mv_obj() {
  if [[ ! -e $1 ]]; then
    co_error "File not found : \"${1}\" "
    exit 7
  fi
  mv "$1" "${dep_constants_build_dir}"
  return 0
}

# $1 == path
# co: \\path\\
function convert_to_win_path() {
  local input_path="$1"
  local win_path="${input_path//\//\\}"
  echo "$win_path"
} 

resolve_specific_paths
# generation of object files
cd "${dep_constants_src_dir}" || cd_unsuc "${dep_constants_src_dir}"
pwd
"$(dep_get_path "ml64")" -c main.asm
echo "$(dep_get_path "ml64")"
mv_obj main.obj
cd - > /dev/null || cd_unsuc_return
# ====

# linking
cd "${dep_constants_build_dir}" || cd_unsuc "${dep_constants_build_dir}"
pwd
"$(dep_get_path "linker")" main.obj -subsystem:console -entry:main "${dep_constants_libs_dir}/kernel32.Lib"
cd - > /dev/null || cd_unsuc_return
# ====
