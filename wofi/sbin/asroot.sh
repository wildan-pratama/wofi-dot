#!/usr/bin/env bash
source $HOME/.config/wofi/theme.bash

export SUDO_ASKPASS="`which password.sh`"

prompt="Run Applications As Root"

if [[ "$icon" == 'no' ]]; then
	option_1=" Terminal"
	option_2=" Thunar"
	option_3=" Geany"
	option_4=" Vim"
	option_5=" Custom"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
fi

woficustom () {
	wofi \
	--conf "$pathconf" \
	--style "$pathstyle" \
	--show dmenu \
	--prompt "$prompt" \
	--height 100 \
	--width 300 \
	--location center
}

runwofi () {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | wofidmenu
}

run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		sudo -A -E kitty
	elif [[ "$1" == '--opt2' ]]; then
		sudo -A -E thunar
	elif [[ "$1" == '--opt3' ]]; then
		sudo -A -E geany
	elif [[ "$1" == '--opt4' ]]; then
		sudo -A -E kitty -e vim
	elif [[ "$1" == '--opt5' ]]; then
		custom="$(woficustom)"
		if [ -z "$custom" ]; then
		exit 1
		fi
		sudo -A -E "$custom"
	fi
}

chosen="$(runwofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac
