#!/bin/bash

source scripts/utils.sh echo -n

datalad --version >/dev/null && _DATALAD_PYTHON3=$(which python3)

_python3_version=$(git config --file scripts/config/python3_config --get python3.version || echo -n)
init_venv --name cp${_python3_version}/py --prefix .tmp/

[[ -z "${_DATALAD_PYTHON3}" ]] || [[ "${_DATALAD_PYTHON3}" != "$(which python3)" ]]
python3 "$@"
