#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

_SNAME=$(basename "$0")

mkdir -p logs/

_VERSION=v1.0

# Download dataset
files=(
	"can_bus.zip"
	"nuScenes-map-expansion-v1.3.zip"
	"v1.0-mini.tgz"
	"v1.0-test_blobs.tgz"
	"v1.0-test_meta.tgz"
	"v1.0-trainval01_blobs.tgz"
	"v1.0-trainval02_blobs.tgz"
	"v1.0-trainval03_blobs.tgz"
	"v1.0-trainval04_blobs.tgz"
	"v1.0-trainval05_blobs.tgz"
	"v1.0-trainval06_blobs.tgz"
	"v1.0-trainval07_blobs.tgz"
	"v1.0-trainval08_blobs.tgz"
	"v1.0-trainval09_blobs.tgz"
	"v1.0-trainval10_blobs.tgz"
	"v1.0-trainval_meta.tgz")

for file in "${files[@]}"
do
	echo --include "${file}"
done | xargs aws s3 cp --recursive --no-sign-request s3://motional-nuscenes/public/${_VERSION}/ . \
	--exclude "*"
	1>>logs/${_SNAME}.out_$$ 2>>logs/${_SNAME}.err_$$

for d in *.tgz
do
	echo "$d"
done | add_files

# Verify dataset
if [[ -f md5sums ]]
then
	md5sum -c md5sums
fi
list -- --fast | while read f
do
	if [[ -z "$(echo "${f}" | grep -E "^bin/")" ]] &&
		[[ -z "$(grep -E " (\./)?${f//\./\\.}$" md5sums)" ]]
	then
		md5sum "${f}" >> md5sums
	fi
done
