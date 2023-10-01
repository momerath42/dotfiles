#!/usr/bin/env bash

# Color files
PFILE="$HOME/.config/polybar/woods/colors.ini"
RFILE="$HOME/.config/polybar/woods/scripts/rofi/colors.rasi"

# Get colors
#pywal_get() {
#	wal -i "$1" -q -t
#}

# Change colors
change_color() {
	# polybar
	sed -i -e "s/background = #.*/background = $BG/g" $PFILE
	sed -i -e "s/background-alt = #.*/background-alt = $BGA/g" $PFILE
	sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
	sed -i -e "s/foreground-alt = #.*/foreground-alt = $FGA/g" $PFILE
	sed -i -e "s/primary = #.*/primary = $AC/g" $PFILE
        sed -i -e "s/sep = #.*/sep = $C5/g" $PFILE
	sed -i -e "s/red = #.*/red = $C2/g" $PFILE
        sed -i -e "s/orange = #.*/orange = $C7/g" $PFILE
	sed -i -e 's/yellow = #.*/yellow = #F57F17/g' $PFILE

	# rofi
	cat > $RFILE <<- EOF
	/* colors */

	* {
	  al:   #00000000;
	  bg:   ${BGA}FF;
	  bga:  ${BG}FF;
	  fga:  ${FGA}FF;
	  fg:   ${FG}FF;
	  ac:   ${AC}FF;
          se:   ${SE}EE;
	}
	EOF
}

# Main
#if [[ -f "/usr/bin/wal" ]]; then
#	if [[ "$1" ]]; then
#		pywal_get "$1"

# Source the pywal color file
. "$HOME/.cache/wal/colors.sh"

BG=`printf "%s\n" "$background"`
FG=`printf "%s\n" "$foreground"`
BGA=`printf "%s\n" "$color6"`
FGA=`printf "%s\n" "$color2"`
AC=`printf "%s\n" "$color3"`
SE=`printf "%s\n" "$color1"`
C7=`printf "%s\n" "$color7"`
C5=`printf "%s\n" "$color5"`
C2=`printf "%s\n" "$color2"`

change_color
