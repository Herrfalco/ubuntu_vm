#!/bin/sh

#resolution="3456 2160 60"
resolution="3840 2160 60"
display="Virtual-1"
modeline=$(cvt $resolution | grep 'Modeline' | cut -d ' ' -f 2-)
name=$(echo $modeline | cut -d ' ' -f 1)

if ! xrandr | grep -q "$name"; then
	xrandr --newmode $modeline
	xrandr --addmode $display $name
fi

xrandr --output $display --mode $name

