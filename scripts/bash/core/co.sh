#!/bin/bash
source ./colorful.sh

declare -A co_prefixes=(
  ["error"]="[X]"
  ["warn"]="[!]"
  ["info"]="[i]"
  ["suc"]="[V]"
  ["msg"]="[*]"
)
co_after_prefix_gap=' '

function co_stack_trace() {
  echo -e "$(cf_bold 1)Stack trace:$(cf_bold 0)"
  
  for (( i=1; i < ${#FUNCNAME[@]}; i++ )); do
    local func="${FUNCNAME[$i]}"
    local file="${BASH_SOURCE[$i]}"
    local line="${BASH_LINENO[$((i-1))]}"
    
    if [[ "$func" == "main" ]]; then func="main (root)"; fi
    
    echo -e "  at $func$(cf_italic 1) $(cf_underline 1)$(cf_bold 1)${file}:${line}$(cf_italic 0)$(cf_underline 0)$(cf_bold 0)"
  done
}

function co_error() {
  if [[ $# -ne 1 ]]; then
    core_error "Invalid args"
    return 1
  fi
  echo -e "$(cf_fb "red")$(cf_bold 1)${co_prefixes["error"]}${co_after_prefix_gap}$(cf_bold 0)$(cf_fb "light_red")${1}$(cf_nc)"
  cf_fb "red"; co_stack_trace; cf_nc;
  return 0
}
function co_warn() {
  if [[ $# -ne 1 ]]; then
    core_error "Invalid args"
    return 1
  fi
  echo -e "$(cf_fb "orange")$(cf_bold 1)${co_prefixes["warn"]}${co_after_prefix_gap}$(cf_bold 0)$(cf_fb "yellow")${1}$(cf_nc)"
  cf_fb "yellow"; co_stack_trace; cf_nc;
  return 0
}
function co_info() {
  if [[ $# -ne 1 ]]; then
    core_error "Invalid args"
    return 1
  fi
  echo -e "$(cf_fb "blue")$(cf_bold 1)${co_prefixes["info"]}${co_after_prefix_gap}$(cf_bold 0)$(cf_fb "cyan")${1}$(cf_nc)"
  return 0
}
function co_suc() {
  if [[ $# -ne 1 ]]; then
    core_error "Invalid args"
    return 1
  fi
  echo -e "$(cf_fb "green")$(cf_bold 1)${co_prefixes["suc"]}${co_after_prefix_gap}$(cf_bold 0)$(cf_fb "light_green")${1}$(cf_nc)"
  return 0
}
function co_msg() {
  if [[ $# -ne 1 ]]; then
    core_error "Invalid args"
    return 1
  fi
  echo -e "$(cf_fb "dark_gray")$(cf_bold 1)${co_prefixes["msg"]}${co_after_prefix_gap}$(cf_bold 0)$(cf_fb "light_gray")${1}$(cf_nc)"
  return 0
}
