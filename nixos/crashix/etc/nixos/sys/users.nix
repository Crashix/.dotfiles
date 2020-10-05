{ config, pkgs, ... }:


{
  users.users.crashix = {
    isNormalUser = true;
    home = "/home/crashix";
    description = "Crashix";
    extraGroups = [ "wheel" "networkmanager" ];
  #  openssh.authorizedKeys.keys = [ "ssh-dss AAAA...... alice@foobar" ];
  };

}
