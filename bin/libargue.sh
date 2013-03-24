#!/usr/bin/env bash
# 
# argue
#

argue() {
  opts=() # ensure bash array is properly initialized
  local arg
  local expanded=()
  local positional=()
  local option_forms=("$@")
  
  # expand "-zxvf" style options to "-z -x -v -f"
  argue_expand
  
  # extract options and positional arguments
  argue_extract || return 1
  
  # export positional args
  args=("${positional[@]}")
}

argue_expand() {
  local i
  local a=0
  for arg in "${args[@]}"
  do
    if echo "$arg" | grep -q "^-[^-]"
    then
      for ((i=1; i<${#arg}; i++))
      do
        expanded[((a++))]="-${arg:i:1}"
      done
    else
      expanded[((a++))]="$arg"
    fi
  done
}

argue_extract() {
  local f
  local r=0
  local a=0
  local forms
  local capture
  for arg in "${expanded[@]}"
  do
    
    # if the capture flag is set the
    # next arg is an option value
    if [ -n "$capture" ]
    then
      opts["$f"]="$arg"
      unset capture
      
    # is $arg is an option or simply a positional argument?
    else
      f=0
      for forms in "${option_forms[@]}"
      do
        
        # check arg against each option form
        argue_detect_option
        
        # if the arg matches a form capture it
        argue_capture_option
      done
      
      # if we still have $arg here it's either an 
      # unrecognized option or a positional argument
      argue_capture_positional || return 1
    fi
  done
}

argue_detect_option() {
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

argue_capture_option() {
  if [ -n "$capture" ]
  then
    if [ "${forms: -1}" != "+" ]
    then
      opts["$f"]="$capture"
      unset capture
    fi
    unset arg
    break
  else
    ((f++))
  fi
}

argue_capture_positional() {
  if [ -n "$arg" ]
  then
    if [ "${arg:0:1}" != "-" ]
    then
      positional[((a++))]="$arg"
    elif [ "${#option_forms[@]}" != 0 ]
    then
      echo "unrecognized option: $arg" >&2 && return 1
    fi
  fi
}