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
        sha256 = "sha256-T5eoG861JJdGj6swp4+icjzwtSB5TY4efy5FeYbgHeg=";
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
    historyLimit = 1000;
    tmuxinator.enable = true;

    extraConfig = ''
      set-option -g detach-on-destroy off
      bind-key -n C-s next-window
      bind-key -n C-t switch-client -n
      bind-key -n C-n switch-client -p
      bind-key -n C-h previous-window
      bind-key M-o send-prefix
      bind-key -n C-g copy-mode \;
      bind-key b set-option status
      set -g status-interval 5

      set -g default-terminal tmux-256color
      set -as terminal-overrides ',tmux-256color:RGB'
      set -as terminal-overrides ',tmux-256color:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',tmux-256color:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{256}%/%d::%p1%{256}%d%m'


      bind x kill-session
      bind M-x kill-session
      bind M-n next-window
      bind M-p previous-window
      set -s escape-time 20
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
