#!/usr/bin/env bash
source $HOME/.config/wofi/theme.bash

status="`mpc status`"

if [[ -z "$status" ]]; then
	prompt="Offline"
else
	artist_title=$(mpc -f "%artist% - %title%" current)
	prompt="Current Track: "$artist_title""
fi

rpt=""
rdm=""
# Repeat
if [[ ${status} == *"repeat: on"* ]]; then
    rpt="on"
elif [[ ${status} == *"repeat: off"* ]]; then
    rpt="off"
else
    option_5=" Parsing Error"
fi


# Random
if [[ ${status} == *"random: on"* ]]; then
    rdm="on"
elif [[ ${status} == *"random: off"* ]]; then
    rdm="off"
else
    option_6=" Parsing Error"
fi


if [[ "$icon" == 'no' ]]; then
	if [[ ${status} == *"[playing]"* ]]; then
		option_1=" Pause"
	else
		option_1=" Play"
	fi
	option_2=" Stop"
	option_3=" Previous"
	option_4=" Next"
	option_5=" Repeat ("$rpt")"
	option_6=" Random ("$rdm")"
else
	if [[ ${status} == *"[playing]"* ]]; then
		option_1=""
	else
		option_1=""
	fi
	option_2=""
	option_3=""
	option_4=""
	option_5=""
	option_6=""
fi


# Toggle Actions
active=''
urgent=''
# Repeat
if [[ ${status} == *"repeat: on"* ]]; then
    rpt="on"
elif [[ ${status} == *"repeat: off"* ]]; then
    rpt="off"
else
    option_5=" Parsing Error"
fi


# Random
if [[ ${status} == *"random: on"* ]]; then
    [ -n "$active" ] && active+=",5" || active="-a 5"
elif [[ ${status} == *"random: off"* ]]; then
    [ -n "$urgent" ] && urgent+=",5" || urgent="-u 5"
else
    option_6=" Parsing Error"
fi

runwofi () {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | wofidmenu
}


# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		mpc -q toggle && kunst --size 60x60 --silent
	elif [[ "$1" == '--opt2' ]]; then
		mpc -q stop
	elif [[ "$1" == '--opt3' ]]; then
		mpc -q prev && kunst --size 60x60 --silent
	elif [[ "$1" == '--opt4' ]]; then
		mpc -q next && kunst --size 60x60 --silent
	elif [[ "$1" == '--opt5' ]]; then
		mpc -q repeat
	elif [[ "$1" == '--opt6' ]]; then
		mpc -q random
	fi
}

# Actions
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
    $option_6)
		run_cmd --opt6
        ;;
esac

