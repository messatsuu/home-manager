# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # # nix-channels
  # TODO: how ho specify channels in config?
  # nix = {
  #   package = pkgs.nixStable; # Use the stable Nix package if necessary
  #   nixPath = [
  #     "stable=https://nixos.org/channels/nixos-24.05"
  #     "nixpkgs=https://nixos.org/channels/nixos-unstable"
  #   ];
  # };
  

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    useOSProber = true;
    efiSupport = true;

    # GRUB Customization
    splashImage = /home/nicolas/.config/dotfiles/pics/anya.png;
    fontSize = 16;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # NOTE: testing fixes for freeze with this:
  boot.kernelPackages = pkgs.linuxPackages_6_1;
  # Enable all sysrq functions (useful to recover from some issues):
  boot.kernel.sysctl."kernel.sysrq" = 1; # NixOS default: 16 (only the sync command)
  # Documentation: https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html

  boot.extraModprobeConfig = ''
    options rtw88_pci disable_aspm=1
  '';

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nicolas = {
    isNormalUser = true;
    description = "Nicolas Hirsig";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # adds docker
  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

 # Set session variables
  environment = {
    variables = {
      # If cursor is not visible, try to set this to "on".
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      T_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };  
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.zsh.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   neovim
   tmux
   ripgrep
   fd
   kitty
   # git
   gitFull
   home-manager
   firefox
   wl-clipboard
   pavucontrol
  #  wget
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # foo bar
  ];

  # Audio output with pulseaudio
  # sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };

  # TODO: fix sddm as display manager
  # services.xserver.displayManager.sddm = {
  #   enable = true;
  #
  #   wayland = {
  #     enable = true;
  #     # compositorCommand = "${lib.getExe' pkgs.kdePackages.kwin "kwin_wayland"} --drm --no-lockscreen --no-global-shortcuts --locale1";
  #   };
  #
  #   extraPackages = with pkgs; [
  #     kdePackages.layer-shell-qt
  #   ];
  #
  #   settings = {
  #  #    General = {
  #  #      GreeterEnvironment = lib.concatStringsSep "," [
  #  # "QT_WAYLAND_SHELL_INTEGRATION=layer-shell"
  #  #      ];
  #  #    };
  #
  #     Theme = {
  #       # Both of these are nessecary otherwise the cursor isn't shown at all
  #       CursorTheme = "breeze_cursors";
  #       CursorSize = 24;
  #     };
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
