#!/bin/bash
set -o errexit -o pipefail -o noclobber

function acquire_lock {
	if [ -e .tmp/lock_stats ]
	then
		[[ "$$" -eq "`cat .tmp/lock_stats`" ]] || return 1
	else
		mkdir -p .tmp/
		echo -n "$$" > .tmp/lock_stats
		chmod -wx .tmp/lock_stats
		[[ "$$" -eq "`cat .tmp/lock_stats`" ]] || return 1
	fi
}

function delete_lock {
	rm -f .tmp/lock_stats
}

function if_empty {
	if [[ -z "$1" ]]
	then
		echo -n "$2"
	else
		echo -n "$1"
	fi
}

declare -a _dirs

_STDIN=0
while [[ $# -gt 0 ]]
do
	_arg="$1"; shift
	case "${_arg}" in
		--stdin) _STDIN=1
		echo "stdin = [${_STDIN}]"
		;;
		--) break ;;
		-h | --help)
		>&2 echo "Options for $(basename "$0") are:"
		>&2 echo "--stdin force read directories from stdin instead of script's arguments"
		exit 1
		;;
		*) _dirs+=("${_arg}") ;;
	esac
done

acquire_lock || exit 1

trap delete_lock EXIT

if [[ ${#_dirs[@]} == 0 ]] || [[ ${_STDIN} == 1 ]]
then
	readarray -t _dirs
fi

rm -f files_count.stats
find "${_dirs[@]}" -type d | sort | while read d
do
	fc=$(find "$d" -maxdepth 1 -type f | wc -l)
	if [[ "$fc" -ne 0 ]]
	then
		printf "%d\t%s\n" "$fc" "$d"
	fi
done > files_count.stats

rm -f disk_usage.stats
find "${_dirs[@]}" -type d | sort | while read d
do
	du=$(find "$d" -maxdepth 1 -type f | xargs -r du -c | tail -n1 | cut -f1)
	if [[ ! -z "$du" ]]
	then
		printf "%d\t%s\n" "$du" "$d"
	fi
done > disk_usage.stats

for d in "${_dirs[@]}"
do
	chmod -R a-w "$d"
done
