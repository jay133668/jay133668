#!/bin/bash

arg=$1


set_proxy() {
	export ALL_PROXY=socks5://127.0.0.1:port
	export HTTP_PROXY=http://127.0.0.1:port2
	export HTTPS_PROXY=http://127.0.0.1:port2

	export all_proxy=socks5://127.0.0.1:port
	export http_proxy=http://127.0.0.1:port2
	export https_proxy=http://127.0.0.1:port2
}

unset_proxy() {
	unset ALL_PROXY
	unset HTTP_PROXY
	unset HTTPS_PROXY

	unset all_proxy
	unset http_proxy
	unset https_proxy
}

help() {
	echo "    help:"
	echo "       set      set proxy"
	echo "       unset    unset proxy"
	echo "       proxy    check proxy"
	echo "       help     help information"
}

if [[ $arg = 'set' ]];then
	set_proxy
elif [[ $arg = 'unset' ]];then
	unset_proxy
elif [[ $arg = 'proxy' ]];then
	env |grep -i proxy
else
	help
fi

