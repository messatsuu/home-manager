{ pkgs, ... }:
let
  minimal-tmux = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "minimal";
      version = "v1.0";
      rtpFilePath = "minimal.tmux";
      src = pkgs.fetchFromGitHub {
        owner = "niksingh710";
        repo = "minimal-tmux-status";
        rev = "main";
        sha256 = "sha256-k/rEvNWUTge1uYwwSMfgM7CDoKanIm8ED3vo5mqDe08=";
      };
    };
in
{
  programs.tmux = {
    enable = true;

    # escapeTime = 10;
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    baseIndex = 1;
    # terminal = "screen-256color";
    terminal = "tmux-256color";
    # historyLimit = 1000;
    tmuxinator.enable = true;

    extraConfig = ''
      set-option -g detach-on-destroy off
      set -ga terminal-overrides ",*256col*:Tc"
      bind-key -n C-s next-window
      bind-key -n C-t switch-client -n
      bind-key -n C-n switch-client -p
      bind-key -n C-h previous-window
      bind-key M-o send-prefix
      bind-key -n C-g copy-mode \;
      bind-key b set-option status

      bind x kill-session
      bind M-x kill-session
      bind M-n next-window
      bind M-p previous-window
      set -s escape-time 0
    '';

    plugins = with pkgs; [
      {
        plugin = minimal-tmux;
        extraConfig = ''
          set -g @minimal-tmux-use-arrow true
          set -g @minimal-tmux-right-arrow ""
          set -g @minimal-tmux-left-arrow ""
        '';
      }
    ];
  };
}
