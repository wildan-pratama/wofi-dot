#!/bin/bash

source $HOME/.config/wofi/theme.bash

wofi \
	--conf "$pathconf" \
	--style "$pathstyle" \
	--show drun \
	--prompt "Launcher" \
	--height 400 \
	--width 500
