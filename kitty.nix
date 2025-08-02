{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    shellIntegration.enableZshIntegration = true;
    themeFile = "Catppuccin-Macchiato";

    extraConfig = ''
      adjust_line_height 130%
      enable_audio_bell yes
      enabled_layouts tall:bias=50;full_size=1;mirrored=false
      background #16161E
      cursor_trail 3
      cursor_trail_decay 0.2 0.3
      cursor_trail_start_threshold 2
    '';
  };
}
