#
# System Menu
#

{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;        # Theme.rasi alternative. Add Theme here
  rofi-theme = {    
    "*" = {
      bg = mkLiteral "#11121D";
      bg-alt = mkLiteral "#444b6a";

      fg = mkLiteral "#FFFFFF";
      fg-alt = mkLiteral "#787c99";

      background-color = mkLiteral "@bg";

      border = 0;
      margin = 0;
      padding = 0;
      spacing = 0;
    };

    "window" = {
      width = mkLiteral "30%";
    };

    "element" = {
      padding = mkLiteral "8 0";
      text-color = mkLiteral "@fg-alt";
    };

    "element selected" = {
      text-color = mkLiteral "@fg";
    };

    "element-text" = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
      vertical-align = mkLiteral "0.5";
    };

    "element-icon" = {
      size = 30;
    };

    "entry" = {
      background-color = mkLiteral "@bg-alt";
      padding = 12;
      text-color = mkLiteral "@fg";
    };

    "inputbar" = {
      children = mkLiteral "[prompt, entry]";
    };

    "listview" = {
      padding = mkLiteral "8 12";
      background-color = mkLiteral "@bg";
      columns = 1;
      lines = 8;
    };

    "mainbox" = {
      background-color = mkLiteral "@bg";
      children = mkLiteral "[inputbar, listview]";
    };

    "prompt" = {
      background-color = mkLiteral "@bg-alt";
      enabled = true;
      padding = mkLiteral "12 0 0 12";
      text-color = mkLiteral "@fg";
    };
  };
in
{
  programs = {
    rofi = { 
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";           # Alacritty is default terminal emulator
      location = "center";
      theme = rofi-theme;                                     # Use theme from above
    };
  };
}
