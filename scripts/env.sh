#!/bin/bash

source scripts/utils.sh echo -n

datalad --version >/dev/null && _DATALAD_PYTHON3=$(which python3)

_python3_version=$(git config --file scripts/config/python3_config --get python3.version || echo -n)
init_venv --name cp${_python3_version}/py --prefix .tmp/

[[ -z "${_DATALAD_PYTHON3}" ]] || [[ "${_DATALAD_PYTHON3}" != "$(which python3)" ]]
exit_on_error_code "Current python env [$(which python3)] is the same as datalad [${_DATALAD_PYTHON3}]"

if [[ ! -z "$@" ]]
then
	"$@"
fi
