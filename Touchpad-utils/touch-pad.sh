#!/usr/bin/sh
set -eu

# shellcheck disable=SC2034
VERSION="0.1"
PROG=${0##*/}

# shellcheck disable=SC1083
# @getoptions
parser_definition() {
  setup   REST help:usage -- "Usage: $PROG [options]... [arguments]..." ''
  msg -- 'Options:'
#  flag    ENABLE    -e --enable               -- "タッチバッドを有効にする"
#  flag    DISABLE   -d --disable              -- "タッチバッドを無効にする"
#  flag    FLAG    -f --flag                 -- "takes no arguments"
#  param   PARAM   -p --param                -- "takes one argument"
  param   TPAD   -t --tpad pattern:"enable|disable" -- "タッチパッドをenableかdisableか"
#  option  OPTION  -o --option on:"default"  -- "takes one optional argument"
  disp    :usage  -h --help
  disp    VERSION    --version
}
# @end

# @gengetoptions parser -i parser_definition parse
#
#     INSERTED HERE
#
# @end

if [ ! -e /usr/bin/xinput ]; then
  echo "you need to install xinput"
  exit 1
fi

eval "$(getoptions parser_definition) exit 1"

#echo "FLAG: $FLAG, PARAM: $PARAM, OPTION: $OPTION"
echo $#
echo "TPAD: $TPAD"
#printf '%s\n' "$@" # rest arguments

case "$TPAD" in
  "enable" )
    eval "xinput --enable 12" ;;
  "disable" )
    eval "xinput --disable 12" ;;
  * )
    ;;
esac
