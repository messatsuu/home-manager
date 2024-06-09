{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    defaultKeymap = "viins";

    # configuration not settable elsewhere, gets set to .zshrc
    initExtra = ''
      autoload -U colors && colors
      export PS1="%{$fg[green]%}[ %n%{$fg[blue]%}@%m %~ %{$fg[green]%}]%{$reset_color%} "
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end

      bindkey "^[[A" history-beginning-search-backward-end
      bindkey "^[[B" history-beginning-search-forward-end
      bindkey -M viins 'hc' vi-cmd-mode
      bindkey "^P" up-line-or-search
      bindkey "^N" down-line-or-search
    '';

    prezto = {
      enable = true;
      caseSensitive = true;
      editor.keymap = "vi";
    };


    shellAliases = {
      n = "nvim";
      t = "tmux";
      ls = "eza --icons auto";
      c = "clear";
      mux = "tmuxinator";
      dock = "result=\${PWD##*/} && docker exec -ti \${result:-/} \${1:-/bin/bash}";
      updateNix = "su -c \"nix-channel --update && sudo nixos-rebuild switch\"";
      updateHome = "sudo -i nix-channel --update && home-manager switch";

      # timer-work = 'timer -f 45m && dunstify "Timer" "Work session ended"'
      # timer-break = 'timer -f 20m && dunstify "Timer" "Break session ended"'
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };
}
