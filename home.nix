{ config, pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./zsh.nix
    ./kitty.nix
    ./gtk.nix
  ];

  fonts.fontconfig.enable = true;
  # Discord is a proprietary software, so we need to enable it.
  nixpkgs.config.allowUnfree = true;
  
  home = {
    username = "nicolas";

    homeDirectory = "/home/nicolas";

    # This should be the same as the one in configuration.nix, DON'T CHANGE!!
    stateVersion = "23.11"; # Please read the comment before changing.

    packages = with pkgs; [
      # programming / terimanl
      neovim
      tmux
      jq
      zsh
      ripgrep
      fd
      gcc
      git
      nodejs
      eza
      hyfetch
      docker
      docker-compose
      wireplumber # session-manager for pipewire
      vesktop # for sceen-sharing
      # php 
      php81Packages.phpstan
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

      # free time
      gzdoom
      discord

      # Hyprdots packages
      bluez
      bluez-tools
      # bluez-utils
      blueman
      rofi-wayland
      glib # what is this for??
      dunst
      brightnessctl
      dolphin
      imagemagick
      hyprpicker
      swaylock-effects
      wlogout
      waybar
    ];

    sessionVariables = {
      EDITOR = "nvim";
      DOTFILES_PATH = "${config.xdg.configHome}/dotfiles";
      NVIM_PATH = "${config.xdg.configHome}/nvim";
      HOME_MANAGER_PATH = "${config.xdg.configHome}/home-manager";
    };

    activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
      for directory in ${config.xdg.configHome}/home-manager/dotfiles/*; do
        ln -s $directory "${config.xdg.configHome}/$(basename $directory)";
      done
    '';
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
      userName = "messatsuu";
      userEmail = "hirsignicolas@gmail.com";
      aliases = {
        undo = "reset HEAD~1 --mixed";
        amend = "commit -a --amend";
      };
    };

  # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
