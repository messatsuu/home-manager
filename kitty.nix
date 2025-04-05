{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    shellIntegration.enableZshIntegration = true;
    theme = "Catppuccin-Macchiato";

    extraConfig = ''
      adjust_line_height 130%
      enable_audio_bell yes
      enabled_layouts tall:bias=50;full_size=1;mirrored=false
      background #020A0E
    '';
  };
}
