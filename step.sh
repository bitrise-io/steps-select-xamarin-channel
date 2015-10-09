#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$xamarin_backup_path" ]; then
	echo "xamarin_backup_path not defined"
	exit 1
fi

if [ -z "$xamarin_channel" ]; then
	echo "xamarin_channel not defined"
	exit 1
fi

ruby "${THIS_SCRIPTDIR}/step.rb" "$xamarin_backup_path" "$xamarin_channel"