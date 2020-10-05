{ config, pkgs, ... }:

{
  # --------- Import -------------------
  imports = 
    [ 
      # Import hardware conf auto-generated 
      ../hardware-configuration.nix
      # Import Xorg Configuration with nvidia-settings (xorg.conf)
      #./x11.nix
      # Set timezone
      ./timezone.nix
      # Users
      ./users.nix

    ];


  # ---------- OS Prober ---------------
  boot.loader.grub.useOSProber = true;
  
  # ---------- Kernel   ----------------
  # Wifi USB driver:
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];
  
  # ---------- Filesystems -------------
  boot.supportedFilesystems = [ "zfs" ];
  # Use Encrypted ZFS 
  boot.zfs.requestEncryptionCredentials = true;


  # ---------- Networking --------------
  networking.hostName = "crashix";
  networking.hostId = "48ec409e";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp0s20u1.useDHCP = true;
  networking.networkmanager.enable = true;
  # Can not use this with network manager:
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.extraConfig = ''
  ctrl_interface=/run/wpa_supplicant
  ctrl_interface_group=wheel
  '';

  networking.hosts = {
    "192.168.0.22"  = [ "nadeko" ];
  };

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];


  # ---------- Video/X11 ---------------
  services.xserver.enable = true;

  # NVIDIA Drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  # NVIDIA drivers are not free
  nixpkgs.config.allowUnfree = true;
  
  # Window manager
  services.xserver.windowManager.bspwm.enable = true;
  #services.xserver.windowManager.xmonad.enable = true;

  # Display manager
  ## services.xserver.displayManager.sddm.enable = true;
  ## services.xserver.displayManager.gdm.enable = true;

  # Keyboard layout
  services.xserver.layout = "fr";
  # services.xserver.xkbOptions = "eurosign:e";
  
  # Wine 
  hardware.opengl.driSupport32Bit = true;

  # Auto-login
  services.xserver.displayManager.defaultSession = "none+bspwm";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "crashix";

  # ---------- Mouse -------------------
  # Mouse sensitivity
  services.xserver.libinput.accelProfile      = "flat";

  # ---------- Sound -------------------
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  # ---------- Localisation ------------
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Inconsolata";
    keyMap = "fr";
  };

  # ---------- Services ----------------
  # SSH
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Fail2Ban
  services.fail2ban = {
    enable = true;
    
    jails  = {
      # Absolutly debilish
      ssh-jail = 
      ''
        action = iptables-multiport
        filter = sshd
        port   = ssh
        logpath = /var/log/auth.log
        findtime = 666
        bantime  = 6666
        maxretry = 6
      '';
    };

  };

  # Udev rules
  services.udev.packages = with pkgs; [ android-udev-rules ];

  # URxvt
  services.urxvtd.enable = true;

}
