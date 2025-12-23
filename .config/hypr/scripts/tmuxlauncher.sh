#!/usr/bin/env sh

# set variables
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/tmuxinatorselect.rasi"


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

# launch tmuxinator session
if [ ! -z "$RofiSel" ] ; then
    dunstify -a "Terminal" "Tmux Launched" "Tmuxinator session: $RofiSel" -u low

    # **This is insanely cool workaround.**
    # Tmuxinator runs Tmux. Tmux needs to have a TTY associated with it to launch new sessions.
    # Since we are running this script from a non-interactive shell (e.g. Hyprland's exec function, called by a keybinging),
    # tmuxinator/tmux cannot launch a new tmux session. We use a PTY (pseudo terminal)  with `script` to launch tmuxinator.)
    # This only started causing issues when running Hyprland from e.g. a greeter, which does not have a TTY associated with it.
    script -q -c "tmuxinator b \"$prefix/$RofiSel\"" /dev/null
    tmuxinator_exit_code=$?
    dunstify -a "Terminal" "Tmuxinator Exit Code" "Exit code: $tmuxinator_exit_code" -u low
fi
