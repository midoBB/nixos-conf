# Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix
#

{ config, lib, pkgs, inputs, user, ... }:

{
  imports = # Import window or display manager.
    [ ../modules/desktop/bspwm/bspwm.nix ];
  networking.useDHCP = false; # Deprecated but needed in config.

  time.timeZone = "Africa/Tunis"; # Time zone and internationalisation
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr"; # or us/dvorak/etc
  };

  services = {
    printing.enable = true;
    gvfs.enable = true; # These are needed for PCman FM and for distant shares
    udisks2.enable = true;
    devmon.enable = true;
    xserver = {
      layout = "fr"; # XServer keyboard layout
      enable = true; # Enable XServer
      desktopManager.plasma5.enable = true; # Enable Plasma
      displayManager.sddm.enable = true; # SDDM for plasma
      windowManager.i3.enable = true; # Enable i3
      libinput = {
        # Needed for all input devices
        enable = true;
      };
    };
    #   openssh = {                             # SSH
    #     enable = true;
    #     allowSFTP = true;
    #   };
    #   sshd.enable = true;
  };
  systemd.user.services =
    { # These are needed to override KDE default Window Manager
      plasma-kwin_x11 = { enable = false; };
      plasma-i3 = {
        wantedBy = [ "plasma-workspace.target" ];
        description = "I3 for Plasma";
        before = [ "plasma-workspace.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.i3-gaps}/bin/i3";
          Slice = "session.slice";
          Restart = "on-failure";
        };
      };
    };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  };

  fonts.fonts = with pkgs; [
    # Fonts
    jerbrains-mono
    helvetica-neue-lt-std
    meslo-lgs-nf
    source-code-pro
    font-awesome # Icons
    corefonts # MS
    (nerdfonts.override {
      # Nerdfont Icons override
      fonts = [ "FiraCode" ];
    })
  ];

  users = {
    defaultUserShell = pkgs.zsh;
    users.${user} = {
      # System User
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "camera"
        "networkmanager"
        "lp"
        "lpadmin"
        "docker"
        "libvirt"
        "scanner"
        "kvm"
        "libvirtd"
      ];
      shell = pkgs.zsh; # Default shell
    };
  };
  security = {
    # User does not need to give password when using sudo.
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false; # I hate having to enter sudo password
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel")) {
      	return polkit.Result.YES;
          }
      });
    ''; # Removes the need to enter passwords for graphical needs
    pam.services.sddm.enableKwallet = true;

  };

  nix = {
    config.allowUnfree = true; # Allow proprietary software.
    # Nix Package Manager settings
    settings = {
      auto-optimise-store = true; # Optimise syslinks
      experimental-features =
        [ "nix-command" "flakes" ]; # enable nix command and flakes
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes; # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  environment = {
    shells = with pkgs; [ zsh ];
    variables = {
      TERMINAL = "wezterm";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      # Default packages install system-wide
      vim
      git
      git-crypt
      gnupg
      pinentry_qt
      killall
      usbutils
      pciutils
      wget
      xterm
      wezterm
    ];
  };

  programs.gpg.agent = { # needed for git-crypt
    enable = true;
    pinentryFlavor = "qt";
  };
  system = {
    # NixOS settings
    autoUpgrade = {
      # Allow auto update
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.11";
  };

  sound = {
    # ALSA sound enable
    enable = true;
    mediaKeys = {
      # Keyboard Media Keys (for minimal desktop)
      enable = true;
    };
  };

  hardware = {
    # Hardware Audio
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ]; # Extra Bluetooth Codecs
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      ''; # Automatically switch to bluetooth device upon connection
    };
  };

  environment.systemPackages = with pkgs; [
    # Packages installed
    xorg.xev
    xorg.xkill
    xorg.xrandr
    wmctrl
    xdg-utils
  ];
}
