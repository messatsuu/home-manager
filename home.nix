{ config, pkgs, inputs, ... }:

{
  imports = [
    ./tmux.nix
    ./zsh.nix
    ./kitty.nix
    ./gtk.nix
    ./qutebrowser.nix
  ];

  fonts.fontconfig.enable = true;
  # Discord, Spotify-client are proprietary, so we need to enable it.
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "nicolas";

    homeDirectory = "/home/nicolas";

    # This should be the same as the one in configuration.nix, DON'T CHANGE!!
    stateVersion = "23.11"; # Please read the comment before changing.

    packages = with pkgs; [
      # programming / terminal
      tmux
      jq
      zsh
      ripgrep
      fd
      gcc
      nodejs
      eza
      hyfetch
      docker
      docker-compose
      btop
      unzip
      tldr
      timer
      ranger
      warp-terminal
      shellcheck
      killall
      bc # calculator
      # TODO: fix
      # ark
      libnotify

      wireplumber # session-manager for pipewire
      vesktop # for sceen-sharing
      xdg-utils # for opening urls in the browser (e.g. xdg-open)

      # php 
      php83Packages.phpstan

      # fonts
      pkgs.nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans

      # low level programming
      gleam
      erlang # needed for compiling gleam
      gnumake
      go
      cmake

      # free time
      keymapp
      spotify
      obsidian
      cbonsai
      # Gaming
      gzdoom
      libtool
      

      # nvim 
      # needed since lazy.nvim now uses luarocks
      python310
      lua5_1
      lua51Packages.luarocks
      # sqlite # used for telescope's smart_history plugin

      # (lsps since we cannot use mason)
      # nodePackages.volar
      gopls
      gparted
      nil
      # Debugger for LLDB
      vscode-extensions.vadimcn.vscode-lldb
      # asm-lsp

      # Hyprdots packages
      bluez
      bluez-tools
      # bluez-utils
      blueman
      rofi
      # glib # what is this for??
      dunst
      brightnessctl
      alacritty
      
      imagemagick
      hyprpicker
      swaylock-effects
      wlogout
      waybar
      pamixer
      swww
      grimblast
      swappy
      cliphist
      zathura
    ];

    sessionVariables = {
      EDITOR = "nvim";
      DOTFILES_PATH = "${config.xdg.configHome}/dotfiles";
      NVIM_PATH = "${config.xdg.configHome}/nvim";
      HOME_MANAGER_PATH = "${config.xdg.configHome}/home-manager";
    };

    # creates a symlink to the dotfiles in the home-manager directory (if the directory doesn't exist yet)
    activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
      for directory in ${config.xdg.configHome}/home-manager/.config/*; do
        [[ -d "${config.xdg.configHome}/$(basename $directory)" ]] || ln -s $directory "${config.xdg.configHome}/$(basename $directory)";
      done
    '';

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 16;
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh

  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;

      settings = {
        aliases = {
          undo = "reset HEAD~1 --mixed";
          amend = "commit -a --amend";
        };
        user = {
          email = "hirsignicolas@gmail.com";
          name = "messatsuu";
        };
        push = { autoSetupRemote = true; };
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
        syntax-theme = "OneHalfDark";
        hyperlinks = true; # makes file paths clickable in the terminal
        features = "decorations interactive";
        interactive = {
          keep-plus-minus-markers = false;
        };
      };
    };


  # Let Home Manager install and manage itself.
    home-manager.enable = true;
    tofi = {
      enable = true;
      settings = {
        width = "100%";
        height = "100%";
        border-width = 0;
        outline-width = 0;
        padding-left = "35%";
        padding-top = "35%";
        result-spacing = 25;
        num-results = 5;
        font = "JetBrainsMono Nerd Font";
        font-size = 30;
        background-color = "#000A";
        selection-color = "#516AA0";
      };
    };
    #
    # doom-emacs = {
    #   enable = true;
    # };
  };
}
