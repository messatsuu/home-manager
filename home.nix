{ config, pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./zsh.nix
    ./kitty.nix
    ./gtk.nix
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

      wireplumber # session-manager for pipewire
      vesktop # for sceen-sharing
      xdg-utils # for opening urls in the browser (e.g. xdg-open)

      # php 
      php83Packages.phpstan

      # fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      noto-fonts-cjk

      # low level programming
      gleam
      erlang # needed for compiling gleam
      gnumake
      go

      # free time
      keymapp
      spotify
      obsidian
      emacs29-pgtk
      cbonsai
      # Gaming
      gzdoom
      discord
      pcsx2
      (retroarch.override {
        cores = with libretro; [
          bsnes-hd
          swanstation
          mgba
          fceumm
        ];
      })

      # nvim 
      # needed since lazy.nvim now uses luarocks
      python39
      lua5_1
      lua51Packages.luarocks
      # sqlite # used for telescope's smart_history plugin

      # (lsps since we cannot use mason)
      nodePackages.volar
      gopls
      nil
      # Debugger for LLDB
      vscode-extensions.vadimcn.vscode-lldb
      # asm-lsp

      # Hyprdots packages
      bluez
      bluez-tools
      # bluez-utils
      blueman
      rofi-wayland
      # glib # what is this for??
      dunst
      brightnessctl
      
      dolphin
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
      package = pkgs.gnome.adwaita-icon-theme;
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
      userName = "messatsuu";
      userEmail = "hirsignicolas@gmail.com";
      extraConfig = {
        push = { autoSetupRemote = true; };
      };
      aliases = {
        undo = "reset HEAD~1 --mixed";
        amend = "commit -a --amend";
      };
    };

  # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
