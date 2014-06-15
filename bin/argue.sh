#!/usr/bin/env bash
# 
# argue.sh
#

argue() {
  local expanded=()
  local positional=()
  local option_forms=("$@")
  
  opts=() # ensure bash array is properly initialized
  
  # expand "-zxvf" style options to "-z -x -v -f"
  __argue_expand
  
  # extract options and positional arguments
  __argue_extract || return 1
  
  # export positional args
  args=("${positional[@]}")
}

__argue_expand() {
  local i
  local arg
  local a=0
  local val
  local assignment
  for arg in "${argv[@]}"; do
    unset assignment
    if echo "$arg" | grep -q "="; then
      assignment="true"
      val="$(echo "$arg" | sed 's/[^=]*=//')"
      arg="$(echo "$arg" | sed 's/=.*//')"
    fi
    if echo "$arg" | grep -q "^-[^-]"; then
      for ((i=1; i<${#arg}; i++)); do
        expanded[((a++))]="-${arg:i:1}"
      done
    else
      expanded[((a++))]="$arg"
    fi
    if [ -n "$assignment" ]; then
      expanded[((a++))]="$val"
    fi
  done
}

__argue_extract() {
  local f
  local r=0
  local a=0
  local arg
  local forms
  local capture
  for arg in "${expanded[@]}"; do
    
    # if the capture flag is set the
    # next arg is an option value
    if [ -n "$capture" ]; then
      opts["$f"]="$arg"
      capture=""
      
    # is $arg is an option or simply a positional argument?
    else
      f=0
      for forms in "${option_forms[@]}"; do
        
        # check arg against each option form
        __argue_detect_option
        
        # if the arg matches a form capture it
        __argue_capture_option
      done
      
      # if we still have $arg here it's either an 
      # unrecognized option or a positional argument
      __argue_capture_positional || return 1
    fi
  done
}

__argue_detect_option() {
  capture=""
  local form
  local OIFS="$IFS"
  IFS=", "
  for form in $forms; do
    if [ "$arg" = "$form" ] &&
       [ "$arg" != "+" ]; then
      capture="$arg"
      break
    fi
  done
  IFS="$OIFS"
}

__argue_capture_option() {
  if [ -n "$capture" ]; then
    if [ "${forms: -1}" != "+" ]; then
      opts["$f"]="$capture"
      capture=""
    fi
    arg=""
    break
  else
    ((f++))
  fi
}

__argue_capture_positional() {
  if [ -n "$arg" ]; then
    if [ "${arg:0:1}" != "-" ]; then
      positional[((a++))]="$arg"
    elif [ "${#option_forms[@]}" != 0 ]; then
      echo "unrecognized option: $arg" >&2 && return 1
    fi
  fi
}
