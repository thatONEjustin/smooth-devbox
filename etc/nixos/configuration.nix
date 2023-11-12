# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

#  nix.nixPath = [
#    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
#    "nixos-config=$HOME/Documents/github/smooth-devbox/etc/nixos/configuration.nix"
#    "/nix/var/nix/profiles/per-user/root/channels"
#  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts = 
    ''
      192.168.0.31 other-box
    '';

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # GNOME utils
  services.gnome = {
    core-utilities.enable = true;
  };

  # GNOME excludes 
  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany
    gedit
    simple-scan
    yelp
    geary
    seahorse
  ];
  
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
# users.defaultUserShell = pkgs.zsh;

  users.users.justinprime = {
    isNormalUser = true;
    description = "justin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    useDefaultShell = false;
#    shell = pkgs.zsh;
  };

  nix.settings.allowed-users = [
    "@wheel"
  ];

  networking.firewall = {
      allowedTCPPorts = [ 9003 ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ 
      "electron-24.8.6"
    ];
#    packageOverrides = pkgs: {
#        unstable = import <nixos-unstable> {
#            config = config.nixpkgs.config;
#        };
#    };
  };
  
  environment.systemPackages = with pkgs; [
     killall
     neofetch
     neovim
     wget
     git
     btop
     bun
     gnome-extension-manager
     gnomeExtensions.pop-shell
     firefox
     discord
     slack
     obsidian
     docker
#    unstable.ddev
  ];

  environment.etc.hosts = {
      mode = "0644";
  };

  programs = {
      steam.enable = true;
      neovim.enable = true;
  };

  hardware.opengl = {
    driSupport32Bit = true;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  virtualisation.docker = {
      enable = true;
      rootless = {
          enable = true;
          setSocketVariable = true;
      };
  };

#  system.activationScripts = ''
#    ln -s $HOME/Documents/github/smooth-devbox/home/.config/home-manager/home.nix $HOME/.config/home-manager/home.nix
#  '';

  system.stateVersion = "23.05"; # Don't delete
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
}
