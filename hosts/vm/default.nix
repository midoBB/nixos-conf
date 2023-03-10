#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   └─ ./hosts
#       └─ ./vm
#            ├─ default.nix *
#            └─ hardware-configuration.nix       
#

{ config, pkgs, ... }:

{
  imports =  [                                  # For now, if applying to other system, swap files
    ./hardware-configuration.nix                # Current system hardware config @ /etc/nixos/hardware-configuration.nix
  ];

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                                  # For legacy boot:
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";                    # Name of harddrive (can also be vda)
      };
      timeout = 1;                              # Grub auto select time
    };
  };

  networking = {
    hostName = "nixos";
    interfaces = {
      enp0s3.useDHCP = true;                    # Change to correct network driver.
    };
  };

  services = {
    xserver = {                                 
      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 3840; y = 2160; }
      ];
    };
  };
}
