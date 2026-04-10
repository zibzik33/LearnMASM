#!/bin/bash
cf_es_nc="\033[0m" # Color reset (no color)


declare -Ar cf_es_fg=( # fg == Foreground

["black"]="\033[30m"
["red"]="\033[31m"
["green"]="\033[32m"
["orange"]="\033[33m"
["blue"]="\033[34m"
["purple"]="\033[35m"
["cyan"]="\033[36m"
["light_gray"]="\033[37m"

["dark_gray"]="\033[90m"
["light_red"]="\033[91m"
["light_green"]="\033[92m"
["yellow"]="\033[93m"
["light_blue"]="\033[94m"
["light_purple"]="\033[95m"
["light_cyan"]="\033[96m"
["white"]="\033[97m"

)

declare -Ar cf_es_bg=( # bg == Background

["black"]="\033[40m"
["red"]="\033[41m"
["green"]="\033[42m"
["orange"]="\033[43m"
["blue"]="\033[44m"
["purple"]="\033[45m"
["cyan"]="\033[46m"
["light_gray"]="\033[47m"

["dark_gray"]="\033[100m"
["light_red"]="\033[101m"
["light_green"]="\033[102m"
["yellow"]="\033[103m"
["light_blue"]="\033[104m"
["light_purple"]="\033[105m"
["light_cyan"]="\033[106m"
["white"]="\033[107m"

)

function core_error() {
  echo -e "${cf_es_fg["red"]}[CO_CORE_ERROR] ${1}${cf_nc}"
}

# $1 == state
# $2 == when is on
# $3 == when is off
function cf_generic_style_switcher() {
  if [[ $# != 3 ]]; then
    core_error "Invalid args"
  fi
  if [[ $1 == '0' ]]; then
    echo -ne "${3}" 
    return 0
  elif [[ $1 != '1' && $1 != "" ]]; then
    core_error "Invalid arg"
    return 1
  fi
  echo -ne "${2}" 
  return 0
}

function cf_bold() {
  cf_generic_style_switcher "$1" "\033[1m" "\033[22m"
}

function cf_italic() {
  cf_generic_style_switcher "$1" "\033[3m" "\033[23m"
}

function cf_underline() {
  cf_generic_style_switcher "$1" "\033[4m" "\033[24m"
}

function cf_strikethrough() {
  cf_generic_style_switcher "$1" "\033[9m" "\033[29m"
}

function cf_double_underline() {
  cf_generic_style_switcher "$1" "\033[21m" "\033[24m"
}

function cf_fb() {
  if [[ $# < 1 || $# > 2 ]]; then
    core_error "Invalid args"
    return 1
  fi
  if [[ $1 != "none" ]]; then
    if [[ -v cf_es_fg[$1] ]]; then
      echo -en "${cf_es_fg[$1]}"
    else
      core_error "An unknown color has been passed for the foreground : \"${1}\". If you want to omit this argument, use none"
      return 2
    fi
  fi
  if [[ -n "$2" ]]; then
    if [[ -v cf_es_bg[$2] ]]; then
      echo -en "${cf_es_bg[$2]}"
    else
      core_error "An unknown color has been passed for the background : \"${2}\". If you want to omit this argument, use none"
      return 3
    fi
  fi
  return 0
}

function cf_nc() {
  echo -ne "${cf_es_nc}"
  return 0
}

function cf_test() {
  for key in "${!cf_es_fg[@]}"; do
    echo -e "$(cf_fb ${key})█$(cf_nc)\
$(cf_fb "none" ${key}) $(cf_nc)\
 - ${key}$(cf_nc)"
  done
  return 0
}
