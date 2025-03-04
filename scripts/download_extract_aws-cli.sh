#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# this script is meant to be used with 'datalad run'

# Download aws
rm -f bin/awscli-exe-linux-x86_64.zip

files_url=(
	"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip bin/awscli-exe-linux-x86_64.zip")

for file_url in "${files_url[@]}"
do
	echo "${file_url}"
done | add_urls

# Install aws-cli
unzip -d .tmp/ bin/awscli-exe-linux-x86_64.zip || \
exit_on_error_code "Failed to extract aws-cli"

.tmp/aws/install --install-dir bin/aws-cli --bin-dir bin || \
exit_on_error_code "Failed to install aws-cli"

# Fix links as they all starts with bin/aws-cli from the --install-dir arg
pushd bin/ >/dev/null
ls -t aws-cli/v2/ | while read version
do
	if [[ "${version}" == "current" ]]
	then
		continue
	fi
	ln -sfT "${version}" aws-cli/v2/current
	break
done
ln -sfT aws-cli/v2/current/bin/aws aws
ln -sfT aws-cli/v2/current/bin/aws_completer aws_completer
popd >/dev/null
