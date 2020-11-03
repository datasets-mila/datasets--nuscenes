#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

function get_file_url {
	local _src_w_dest=(${1})
	local _src=${_src_w_dest[0]}
	local _dest=${_src_w_dest[1]}
	local _url=$(curl -s "https://o9k5xn5546.execute-api.us-east-1.amazonaws.com/v1/archives/v1.0/${_dest}" -H "${AUTHORIZATION_TOKEN}")
	local _url=${_url##*https://}
	local _url=${_url%%\"\}*}
	echo "https://${_url} ${_dest}"
}

test_enhanced_getopt

PARSED=$(enhanced_getopt --options "h" --longoptions "curl-options:,refresh-token-data:,help" --name "$0" -- "$@")
eval set -- "${PARSED}"

REFRESH_TOKEN_DATA=$(git config --file scripts/nuscenes_config --get aws.refresh-token-data || echo "")

while [[ $# -gt 0 ]]
do
	arg="$1"; shift
	case "${arg}" in
		--curl-options) CURL_OPTIONS="$1"; shift
		echo "curl-options = [${CURL_OPTIONS}]"
		;;
		--refresh-token-data) REFRESH_TOKEN_DATA="$1"; shift
		echo "refresh-token-data = [${REFRESH_TOKEN_DATA}]"
		;;
		-h | --help)
		>&2 echo "Options for $(basename "$0") are:"
		>&2 echo "--curl-options OPTIONS"
		>&2 echo "--refresh-token-data JSON"
		exit 1
		;;
		--) break ;;
		*) >&2 echo "Unknown argument [${arg}]"; exit 3 ;;
	esac
done

files_url=(
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval_meta.tgz v1.0-trainval_meta.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval01_blobs.tgz v1.0-trainval01_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval02_blobs.tgz v1.0-trainval02_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval03_blobs.tgz v1.0-trainval03_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval04_blobs.tgz v1.0-trainval04_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval05_blobs.tgz v1.0-trainval05_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval06_blobs.tgz v1.0-trainval06_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval07_blobs.tgz v1.0-trainval07_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval08_blobs.tgz v1.0-trainval08_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval09_blobs.tgz v1.0-trainval09_blobs.tgz"
	"https://s3.amazonaws.com/data.nuscenes.org/public/v1.0/v1.0-trainval10_blobs.tgz v1.0-trainval10_blobs.tgz")

AUTHORIZATION_TOKEN=$(curl -s "https://cognito-idp.us-east-1.amazonaws.com/" -X POST \
	-H "Content-Type: application/x-amz-json-1.1" \
	-H "X-Amz-Target: AWSCognitoIdentityProviderService.InitiateAuth" \
	-H "X-Amz-User-Agent: aws-amplify/0.1.x js" --data-raw "${REFRESH_TOKEN_DATA}" \
	| grep -o '"IdToken":"[^\"]*"')
AUTHORIZATION_TOKEN=${AUTHORIZATION_TOKEN%\"*}
AUTHORIZATION_TOKEN="Authorization: Bearer ${AUTHORIZATION_TOKEN##*\"}"

# These urls require login cookies to download the file
git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files \
	-c annex.security.allowed-ip-addresses=all -c annex.web-options="${CURL_OPTIONS}" <<EOF
$(for file_url in "${files_url[@]}" ; do get_file_url "${file_url}" ; done)
EOF
git-annex get -J8
git-annex migrate --fast -c annex.largefiles=anything *
# Set URL without query string
git-annex addurl -c annex.largefiles=anything --raw --relaxed --batch --with-files <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
for f in $(git-annex list --fast | grep -o " .*")
do
	git-annex rmurl --fast "$f" "$(git-annex whereis "$f" | grep -o "https://.*?.*")"
done

md5sum -c md5sums
