#!/bin/bash

log() {
  local type="$1"
  shift

  case "$type" in
    ACTION)
      printf -- "\n- \033[1;4mACTION\033[0m   %s\n\n" "$*"
      ;;
    DONE)
      printf -- "- DONE ✅  %s\n" "$*"
      ;;
    ERROR)
      printf -- "- ERROR ❌  %s\n" "$*"
      ;;
    DETAILS)
      printf -- "           - %s\n" "$*"
      ;;
    NOTICE)
      # First message is treated as the title
      local title="$1"
      shift

      # Calculate maximum line length
      local max_length=${#title}
      for line in "$@"; do
        if [ ${#line} -gt $max_length ]; then
          max_length=${#line}
        fi
      done

      local border=""
      for i in $(seq 1 $((max_length + 8))); do
        border="${border}━"
      done

      printf "\n\033[1;34m╭%s╮\033[0m\n" "$border"
      printf "\033[1;34m┃\033[0m  \033[1;37;1m%s\033[0m\n" "$title"
      for line in "$@"; do
        printf "\033[1;34m┃  \033[1;32m➡  %s\033[0m\n" "$line"
      done
      printf "\033[1;34m╰%s╯\033[0m\n\n" "$border"
      ;;
    *)
      printf -- "- [%s] %s\n" "$type" "$*"
      ;;
  esac
}

log "$@"
