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
# Generated by getoptions (BEGIN)
# URL: https://github.com/ko1nksm/getoptions (v3.3.2)
TPAD=''
REST=''
parse() {
  OPTIND=$(($#+1))
  while OPTARG= && [ "${REST}" != x ] && [ $# -gt 0 ]; do
    case $1 in
      --?*=*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%%\=*}" "${OPTARG#*\=}"' ${1+'"$@"'}
        ;;
      --no-*|--without-*) unset OPTARG ;;
      -[t]?*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%"${OPTARG#??}"}" "${OPTARG#??}"' ${1+'"$@"'}
        ;;
      -[h]?*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%"${OPTARG#??}"}" -"${OPTARG#??}"' ${1+'"$@"'}
        case $2 in --*) set -- "$1" unknown "$2" && REST=x; esac;OPTARG= ;;
    esac
    case $1 in
      '-t'|'--tpad')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        case $OPTARG in enable|disable) ;;
          *) set "pattern:enable|disable" "$1"; break
        esac
        TPAD="$OPTARG"
        shift ;;
      '-h'|'--help')
        usage
        exit 0 ;;
      '--version')
        echo "${VERSION}"
        exit 0 ;;
      --)
        shift
        while [ $# -gt 0 ]; do
          REST="${REST} \"\${$(($OPTIND-$#))}\""
          shift
        done
        break ;;
      [-]?*) set "unknown" "$1"; break ;;
      *)
        REST="${REST} \"\${$(($OPTIND-$#))}\""
    esac
    shift
  done
  [ $# -eq 0 ] && { OPTIND=1; unset OPTARG; return 0; }
  case $1 in
    unknown) set "Unrecognized option: $2" "$@" ;;
    noarg) set "Does not allow an argument: $2" "$@" ;;
    required) set "Requires an argument: $2" "$@" ;;
    pattern:*) set "Does not match the pattern (${1#*:}): $2" "$@" ;;
    notcmd) set "Not a command: $2" "$@" ;;
    *) set "Validation error ($1): $2" "$@"
  esac
  echo "$1" >&2
  exit 1
}
usage() {
cat<<'GETOPTIONSHERE'
Usage: gengetoptions [options]... [arguments]...

Options:
  -t, --tpad TPAD             タッチパッドをenableかdisableか
  -h, --help                  
      --version               
GETOPTIONSHERE
}
# Generated by getoptions (END)
# @end

if [ ! -e /usr/bin/xinput ]; then
  echo "you need to install xinput"
  exit 1
fi

eval "$(getoptions parser_definition) exit 1"

#echo "FLAG: $FLAG, PARAM: $PARAM, OPTION: $OPTION"
#printf '%s\n' "$@" # rest arguments

case "$TPAD" in
  "enable" )
    eval "xinput --enable 12" ;;
  "disable" )
    eval "xinput --disable 12" ;;
  * )
    ;;
esac
