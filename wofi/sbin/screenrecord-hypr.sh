source $HOME/.config/wofi/theme.bash
dir="$HOME/Videos/Screencasts"
time=`date +%Y-%m-%d-%H-%M-%S`
file="$dir/Screencasts_${time}.mp4"
prompt="Screen Record"

work="$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
win="$(hyprctl clients -j | jq -r --argjson workspaces "$work" 'map(select([.workspace.id] | inside($workspaces)))')"

# Directory
if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

if [[ "$icon" == 'no' ]]; then
	option_1=" Stop"
	option_2=" Record current screen"
	option_3=" Record all screen"
	option_4=" Record area"
	yes=" Yes"
	no=" No"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	yes=""
	no=""
fi

audioask() {
	wofi \
		--conf "$pathconf" \
		--style "$pathstyle" \
		--show dmenu \
		--prompt "Are you want record with audio?" \
		--height 230 \
		--width 300 \
		--location center
}

confirmaudio() {
	echo -e "$yes\n$no" | audioask
}


if pgrep -x wf-recorder >/dev/null; then
	opt="$option_1"
	wofidmenu () {
		wofi \
			--conf "$pathconf" \
			--style "$pathstyle" \
			--show dmenu \
			--prompt "$prompt" \
			--height 170 \
			--width 300 \
			--location center
	}
else	
	opt="$option_2\n$option_3\n$option_4"
	wofidmenu () {
		wofi \
			--conf "$pathconf" \
			--style "$pathstyle" \
			--show dmenu \
			--prompt "$prompt" \
			--height 300 \
			--width 500 \
			--location center
	}
fi

runwofi() {
	echo -e "$opt" | wofidmenu
}

# Record
countdown () {
	for sec in `seq $1 -1 1`; do
		notify-send -i $HOME/.local/share/dunst/timer.png "Screenrecording in : $sec" --replace-id=555
		sleep 0.5
		notify-send -i $HOME/.local/share/dunst/video.png "Recording" --replace-id=555
	done
}

# take shots
stop_rec() {
	notify-send -i $HOME/.local/share/dunst/video.png "Record Stop" --replace-id=555
	pkill -2 wf-recorder
	sleep 1
	notify-send -i $HOME/.local/share/dunst/video.png "Video saved on:" "$file" --replace-id=555
	}

## All screen
rec_noaudio() {
	countdown '5'
	wf-recorder -f "$file"
}
rec_audio() {
	countdown '5'
	wf-recorder -a -f "$file"
}

## Current
cur_noaudio() {
	countdown '5'
	wf-recorder -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)' | jq -r '.name')" \
	-f "$file"
}
cur_audio() {
	countdown '5'
	wf-recorder -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)' | jq -r '.name')" \
	-a -f "$file"
}

## Area
area_noaudio() {
	sleep 0.5
	wf-recorder -g "$(echo "$win" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)" \
	-f "$file"
}
area_audio() {
	sleep 0.5
	wf-recorder -g "$(echo "$win" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)" \
	-a -f "$file"
}


# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		stop_rec
	elif [[ "$1" == '--opt2' ]]; then
		selected="$(confirmaudio)"
		if [[ "$selected" == "$yes" ]];
			then
			cur_audio
		elif [[ "$selected" == "$no" ]];
			then
			cur_noaudio
        else
			exit
		fi
	elif [[ "$1" == '--opt3' ]]; then
		selected="$(confirmaudio)"
		if [[ "$selected" == "$yes" ]];
			then
			rec_audio
		elif [[ "$selected" == "$no" ]];
			then
			rec_noaudio
		else
			exit
        fi
	elif [[ "$1" == '--opt4' ]]; then
		selected="$(confirmaudio)"
		if [[ "$selected" == "$yes" ]];
			then
			area_audio
		elif [[ "$selected" == "$no" ]];
			then
			area_noaudio
		else
			exit
        fi
	fi
}

wofisel() {
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
esac
}


# Actions
case $1 in
  -s | --status)
	if pgrep -x wf-recorder >/dev/null; then
		echo '{"text":""}'
	else
		echo ''
	fi
    ;;
  -st | --stop)
	stop_rec
    ;;
  -w | --wofi)
	wofisel
    ;;
esac
