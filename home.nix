{ config, pkgs, ... }:

{
  home = {
    username = "nicolas";

    homeDirectory = "/home/nicolas";

    # This should be the same as the one in configuration.nix, DON'T CHANGE!!
    stateVersion = "23.11"; # Please read the comment before changing.

    packages = with pkgs; [
      neovim
      tmux
      zsh
      ripgrep
      fd
      gcc
      git
      nodejs
      eza
      kitty
      hyfetch
    ];

    sessionVariables = {
      EDITOR = "nvim";
      DOTFILES_PATH = "${config.xdg.configHome}/dotfiles";
      NVIM_PATH = "${config.xdg.configHome}/nvim";
    };

    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;
  
      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh

  # Let Home Manager install and manage itself.

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      # enableCompletion = true;
      # autosuggestion.enable = true;
      # syntaxHighlighting.enable = true;
      autocd = true;
      defaultKeymap = "viins";

      # configuration not settable elsewhere, gets set to .zshrc
      initExtra = ''
        autoload -U colors && colors
        export PS1="%{$fg[green]%}[ %n%{$fg[blue]%}@%m %~ %{$fg[green]%}]%{$reset_color%} "
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
        mux = "tmuxinator";
        t = "tmux";
        ls = "eza --icons";
        # timer-work = 'timer -f 45m && dunstify "Timer" "Work session ended"'
        # timer-break = 'timer -f 20m && dunstify "Timer" "Break session ended"'
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        # theme = "terminalparty";
      };
    };

    tmux = {
      enable = true;

      escapeTime = 10;
      shell = "${pkgs.zsh}/bin/zsh";
      keyMode = "vi";
      baseIndex = 1;
      terminal = "tmux-256color";
      historyLimit = 100000;

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
      '';
      #plugins = [
      #  "janoamaral/tokyo-night-tmux"
      #];
    };
  };

}
