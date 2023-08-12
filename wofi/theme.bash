#!/bin/bash

THEME="Gruvbox"
icon="no"
DIR=""$HOME"/.config/wofi/themes"
pathconf=""$DIR"/"$THEME"/config"
pathstyle=""$DIR"/"$THEME"/style.rasi"

wofidmenu () {
	wofi \
		--conf "$pathconf" \
		--style "$pathstyle" \
		--show dmenu \
		--prompt "$prompt" \
		--height 400 \
		--width 500
}
