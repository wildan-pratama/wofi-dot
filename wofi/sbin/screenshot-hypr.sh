#!/usr/bin/env bash
source $HOME/.config/wofi/theme.bash
dir="$HOME/Pictures/Screenshots"
time=`date +%Y-%m-%d-%H-%M-%S`
file="Screenshot_${time}.png"
prompt="Screenshot"

# Directory
if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

if [[ "$icon" == 'no' ]]; then
	option_1=" Capture Desktop"
	option_2=" Capture All Monitor"
	option_3=" Capture Area"
	option_4=" Capture Window"
	option_5=" Capture in 5s"
	option_6=" Capture in 10s"
else
	option_1=""
	option_2="+"
	option_3=""
	option_4=""
	option_5=""
	option_6=""
fi

runwofi () {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | wofidmenu
}

notify_cmd_shot="notify-send -i $dir/$file -t 2000"
notify_view() {
	$notify_cmd_shot "Copied to clipboard."
	paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &>/dev/null &
	viewnior ${dir}/"$file"
	if [[ -e "$dir/$file" ]]; then
		${notify_cmd_shot} "Screenshot Saved."
	else
		notify-send -i $HOME/.local/share/dunst/picture.png -t 2000 "Screenshot Deleted."
	fi
}

copyshot () {
	wl-copy
}

countdown () {
	for sec in `seq $1 -1 1`; do
		notify-send -i $HOME/.local/share/dunst/timer.png "Taking shot in : $sec" --replace-id=555
		sleep 1
	done
}

shotall () {
	sleep 0.5 && grim "$dir/$file"
	copyshot < "$dir/$file"
	notify_view
}

shot () {
	sleep 0.5 && grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)' | jq -r '.name')" "$dir/$file"
	copyshot < "$dir/$file"
	notify_view
}

shot5 () {
	countdown '5'
	sleep 0.5 && grim "$dir/$file"
	copyshot < "$dir/$file"
	notify_view
}

shot10 () {
	countdown '10'
	sleep 0.5 && grim "$dir/$file"
	copyshot < "$dir/$file"
	notify_view
}

shotwin () {
	sleep 0.5 && grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$dir/$file"
	copyshot < "$dir/$file"
	notify_view
}

shotarea () {
	work="$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
	win="$(hyprctl clients -j | jq -r --argjson workspaces "$work" 'map(select([.workspace.id] | inside($workspaces)))')"
	grim -t png -g "$(echo "$win" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)" "$dir/$file"
	copyshot < "$dir/$file"
	notify_view
}

copy () {
	grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)' | jq -r '.name')" - | copy_shot
	notify-send -i $HOME/.local/share/dunst/picture.png -t 2000 "Copied to clipboard."
	paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &>/dev/null &
}


# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shot
	elif [[ "$1" == '--opt2' ]]; then
		shotall
	elif [[ "$1" == '--opt3' ]]; then
		shotarea
	elif [[ "$1" == '--opt4' ]]; then
		shotwin
	elif [[ "$1" == '--opt5' ]]; then
		shot5
	elif [[ "$1" == '--opt6' ]]; then
		shot10
	fi
}

# Actions
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
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
	esac
}

case $1 in
  -s | --shot)
	shot
    ;;
  -c | --copy)
	copy
    ;;
  -w | --wofi)
	wofisel
    ;;
esac
