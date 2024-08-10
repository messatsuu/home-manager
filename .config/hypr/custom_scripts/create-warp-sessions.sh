#!/bin/bash

mkdir -p /home/nicolas/.local/share/warp-terminal/launch_configurations

for directory in ~/src/*; do
    if [ -d "$directory" ]; then
        dir_name=$(basename "$directory")
        cat <<EOF > "/home/nicolas/.local/share/warp-terminal/launch_configurations/$dir_name.yaml"
---
name: $dir_name
windows:
    - tabs:
        - layout:
            cwd: $directory
            commands:
                - exec: nvim
        - layout:
            cwd: $directory
            commands:
                - exec: dock
EOF
    fi
done;
