#!/bin/bash

source $HOME/.config/wofi/theme.bash

wofi \
	--conf "$pathconf" \
	--style "$pathstyle" \
	--show dmenu \
	--prompt "Enter Password:" \
	--password \
	--height 100 \
	--width 300 \
	--location center
