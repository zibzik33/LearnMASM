#!/bin/bash
source ./utils.sh
declare -A dep_paths

suppress_path_warn=0 # suppress all warnings about non-existent paths 


# $1 == name
# $2 == relative path
# $3 == "true" => error if not found
function dep_add_path() {
  if [[ $# != 2 && $# != 3 ]]; then
    co_error "Invalid args"
    return 1
  fi
  if [[ -v dep_paths[${1}] ]]; then
    co_error "An association for the path named \"${1}\" already exists."
    return 2
  fi
  dep_paths[${1}]="${2}"
  if [[ ! -e $2 ]]; then
    if [[ $3 == "true" ]]; then
      co_error "The path \"${2}\" does not exist"
      exit 4
    elif [[ ${suppress_path_warn} -ne 1 ]]; then
      co_warn "The path \"${2}\" does not exist"
      return 3
    fi
  fi
  return 0
}

# $1 == name
function dep_get_path() {
  if [[ $# != 1 ]]; then
    co_error "Invalid arg"
    return 1
  fi
  if [[ -v dep_paths[$1] ]]; then
    echo -ne "${dep_paths[$1]}"
    return 0
  fi
  co_error "No association with the name \"$1\" found"
  return 2
}

function resolve_main_paths() {
  dep_add_path "cwd" "$(get_script_dir)/../../.." "true"
  dep_constants_cwd=$(dep_get_path "cwd")
  dep_add_path "local" "${dep_constants_cwd}/local" "true"
  dep_constants_local=$(dep_get_path "local")
  dep_add_path "cfgs" "${dep_constants_local}/cfgs" "true"
  dep_constants_cfgs=$(dep_get_path "cfgs")
  dep_add_path "assembly_json" "${dep_constants_cfgs}/assembly.json" "true"
  dep_add_path "src_dir" "${dep_constants_cwd}/src" "true"
  dep_add_path "build_dir" "${dep_constants_cwd}/build" "true"
}

resolve_main_paths # we make magic here :3

