#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/tmuxinatorselect.rasi"


# scale for monitor x res
x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_monres=$(( x_monres * 18 / monitor_scale ))


# set rofi override
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="listview{columns:4;} element{orientation:vertical;border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:${x_monres}px;} element-text{enabled:false;}"


# launch rofi menu
selectable_elements=$(ls $HOME/src)

custom_elements=("home-manager" "nvim")
for element in "${custom_elements[@]}"; do
    selectable_elements+="\n$element"
done

RofiSel=$(printf "$selectable_elements" | rofi -dmenu -config "$RofiConf")


# check if the selected value is in the custom elements
if [[ $(echo ${custom_elements[@]} | fgrep -w $RofiSel) ]]; then
    prefix=".config"
else
    prefix="src"
fi

launch tmuxinator session
if [ ! -z "$RofiSel" ] ; then
    dunstify -a "Terminal" "Tmux Launched" "Tmuxinator session: $RofiSel" -u low
    tmuxinator b "$prefix/$RofiSel"
fi
