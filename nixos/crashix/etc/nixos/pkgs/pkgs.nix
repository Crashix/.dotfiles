{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
    
  environment.systemPackages = with pkgs; [
    git
    dmenu
    polybar
    rxvt-unicode
    borgbackup
    gtop
    android-file-transfer
  ];

}
