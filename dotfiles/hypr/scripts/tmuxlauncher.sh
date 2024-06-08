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
RofiSel=$(ls $HOME/src | sed 's/spitex-bern.ch/spitexb/g;s/cloudtec.ch/cloudtec/g' | rofi -dmenu -config $RofiConf)


# launch tmuxinator sessionc
if [ ! -z $RofiSel ] ; then
    dunstify -a "Terminal" "Tmux Launched" "Tmuxinator session: $RofiSel" -u low
    tmuxinator b $RofiSel
fi
