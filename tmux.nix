{ pkgs, ... }:
let
  tokyo-night-tmux = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tokyo-night";
      version = "v1.5.3";
      # the plugin-file (sourced in .tmux.conf) is not abiding standards (kebab-case instead of snake)
      rtpFilePath = "tokyo-night.tmux";
      src = pkgs.fetchFromGitHub {
        owner = "janoamaral";
        repo = "tokyo-night-tmux";
        rev = "d34f1487b4a644b13d8b2e9a2ee854ae62cc8d0e";
        sha256 = "sha256-3rMYYzzSS2jaAMLjcQoKreE0oo4VWF9dZgDtABCUOtY=";
      };
    };
in
{
  programs.tmux = {
    enable = true;

    escapeTime = 10;
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    baseIndex = 1;
    terminal = "tmux-256color";
    historyLimit = 100;
    tmuxinator.enable = true;

    extraConfig = ''
      set-option -g detach-on-destroy off
      set -ga terminal-overrides ",*256col*:Tc"
      bind-key -n C-h next-window
      bind-key -n C-t switch-client -n
      bind-key -n C-n switch-client -p
      bind-key -n C-s previous-window
      bind-key M-o send-prefix
      bind-key -n C-g copy-mode \;
      bind x kill-session
      bind M-x kill-session
      bind M-n next-window
      bind M-p previous-window
      set -s escape-time 0

      set -g @tokyo-night-tmux_show_path 1
    '';

    plugins = with pkgs; [
      tokyo-night-tmux
    ];
  };
}
