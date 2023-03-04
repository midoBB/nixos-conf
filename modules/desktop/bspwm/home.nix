#
#  Bspwm Home manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ home.nix *
#

{ pkgs, ... }:

{
  xsession = {
    windowManager = {
      bspwm = {
        enable = true;
#        monitors = {                            # Multiple monitors
#          HDMI-A-1 = [ "1" "2" "3" "4" "5" ];
#          HDMI-A-0 = [ "6" "7" "8" "9" "0" ];
#        };
        rules = {                               # Specific rules for apps - use xprop 
          "Emacs" = {
            desktop = "3";
            follow = true;
            state = "tiled";
          };
          ".blueman-manager-wrapped" ={ 
            #center = true;
            state = "floating";
            sticky = true;
          };
          #"Google-chrome" = {
            #desktop = "2";
            #focus = true;
            #manage = false;
          #}; 
          "libreoffice" ={
            desktop = "3";
            follow = true;
          };
          "Lutris" = {
            desktop = "5";
            follow = true;
          };
          "Pavucontrol" = {
            state = "floating";
            #center = true;
            sticky = true;
          };
          "Pcmanfm" = {
            state = "floating";
          };
          "plexmediaplayer" = {
            desktop = "4";
            follow= true;
            state = "fullscreen";
          };
          "*:*:Picture in picture" = {
            state = "floating";
            sticky = true;
          };
          "Steam" = {
            desktop = "5";
            follow = true;
          };
        };
        extraConfig = ''
          feh --bg-scale $HOME/.config/wall     # Wallpaper

          bspc monitor -d 1 2 3 4 5             # Workspace tag names (need to be the same as the polybar config to work)

          bspc config border_width      2
          bspc config window_gaps      12
          bspc config split_ratio     0.5

          bspc config focus_follows_pointer     true
          #bspc config borderless_monocle       true
          #bspc config gapless_monocle          true

          #bspc config normal_border_color  "#44475a"
          #bspc config focused_border_color "#bd93f9"

          #pgrep -x sxhkd > /dev/null || sxhkd &

          killall -q polybar &                  # Reboot polybar to correctly show workspaces

          while pgrep -u $UID -x polybar >/dev/null; do sleep 1;done 

          polybar main & #2>~/log &             # To lazy to figure out systemd service order

          #Setting for desktop:
          if [[ $(xrandr -q | grep 'DisplayPort-1 connected') ]]; then   # If second monitor, also enable second polybar
            #bspc monitor DisplayPort-1 -s HDMI-A-1
            bspc monitor DisplayPort-1 -d 6 7 8 9 10
            bspc wm -O HDMI-A-1 DisplayPort-1
            polybar sec &
          fi
        '';
      };
    };
  };
}
