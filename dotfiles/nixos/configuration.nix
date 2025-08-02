# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

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
  #     "stable=https://nixos.org/channels/nixos-25.05"
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

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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

    # TODO: GDM, or any greeter does not properly work, since hyprland needs to be attached to a tty to spawn certain background processes.
    # enable = true;
    # displayManager.gdm.enable = true;
    # displayManager.gdm.wayland = true;
    # displayManager.sessionPackages = [ pkgs.hyprland ];
    # displayManager.sessionPackages = [
    #   # sessionPackages accepts a package (derivation) with metadata about the session
    #   # This just changes the Hyprland.desktop file to use a different Exec command, that ensures that it 
    #   # starts the session from a tty
    #   (pkgs.stdenv.mkDerivation {
    #     name = "custom-wayland-session";
    #     src = /home/nicolas/.config/home-manager/dotfiles/wayland-sessions;
    #
    #     installPhase = ''
    #       mkdir -p $out/share/wayland-sessions
    #       cp $src/*.desktop $out/share/wayland-sessions/
    #     '';
    #
    #     passthru.providedSessions = [ "hyprland" ];  # Must match .desktop file
    #   })
    # ];
    # libinput.enable = true;

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nicolas = {
    isNormalUser = true;
    description = "Nicolas Hirsig";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
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
    open = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.pulseaudio.enable = false;
  programs.zsh.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
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
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # foo bar
  ];

  # Audio output with pipewire
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
