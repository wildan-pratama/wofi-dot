#!/usr/bin/env bash
source $HOME/.config/wofi/theme.bash

wofidmenu () {
	wofi --conf "$pathconf" --style "$pathstyle" --show dmenu --prompt "$prompt"
}
	
help() {
    cat <<EOF
Usage: wofi.sh [options ..]
Options:
  -h, --help            show help message
  -t, --theme           show available themes and set it
EOF
}



# Wofi Theme
THEMES=(`cd $DIR && ls -d */ | cut -d '/' -f1`)
list-theme() {
	prompt="Themes"
	printf '%s\n' "${THEMES[@]}" | wofidmenu
}

apply_theme() {
	selected="`list-theme`"

	for theme in "${THEMES[@]}"; do
		if [[ -z "$selected" ]]; then
			break
		elif [[ "$selected" == "$theme" ]]; then
			sed -i "$HOME/.config/wofi/theme.bash" -e "s/THEME=.*/THEME=\"$theme\"/g"
			break
		fi
	done
}


case $1 in
  -h | --help)
	help
    ;;
  -t | --theme)
	apply_theme
    ;;
esac


