#!/usr/bin/env bash
# 
# argue.sh
#

argue() {
  local arg
  local temp_args
  local temp_opts
  local option_forms=("$@")
  
  # expand "-zxvf" to "-z -x -v -f"
  __argue_expand
  
  # extract to temporary structures
  __argue_extract || return 1
  
  # export temporary data
  __argue_export
}

__argue_expand() {
  local i
  local a=0
  for arg in "${args[@]}"
  do
    if echo "$arg" | grep -q "^-[^-]"
    then
      for ((i=1; i<${#arg}; i++))
      do
        temp_args[((a++))]="-${arg:i:1}"
      done
    else
      temp_args[((a++))]="$arg"
    fi
  done
  args=("${temp_args[@]}")
}

__argue_extract() {
  unset temp_args
  local f
  local r=0
  local a=0
  local forms
  local capture
  for arg in "${args[@]}"
  do
    
    # if the capture flag is set the
    # next arg is an option value
    if [ -n "$capture" ]
    then
      temp_opts["$f"]="$arg"
      unset capture
      
    # check for options
    else
      f=0
      for forms in "${option_forms[@]}"
      do
        
        # check arg against each option form
        __argue_detect_option
        
        # if the arg matches a form capture it
        __argue_capture_option
      done
      
      # if the arg didn't match an option form 
      # and it's not unrecognized, capture it
      __argue_capture_argument || return 1
    fi
  done
}

__argue_detect_option() {
  unset capture
  local form
  local OIFS="$IFS"
  IFS=", "
  for form in $forms
  do
    if [ "$arg" = "$form" ]
    then
      capture="$arg"
      break
    fi
  done
  IFS="$OIFS"
}

__argue_capture_option() {
  if [ -n "$capture" ]
  then
    if [ "${forms: -1}" != "+" ]
    then
      temp_opts["$f"]="$capture"
      unset capture
    fi
    unset arg
    break
  else
    ((f++))
  fi
}

__argue_capture_argument() {
  if [ -n "$arg" ]
  then
    if [ "${arg:0:1}" != "-" ]
    then
      temp_args[((a++))]="$arg"
    else
      echo "unrecognized option: $arg" >&2
    fi
  fi
}

__argue_export() {
  args=("${temp_args[@]}")
  opts=("${temp_opts[@]}")
}
