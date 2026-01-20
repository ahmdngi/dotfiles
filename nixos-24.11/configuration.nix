# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./hyprland.nix
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  networking.hostName = "oversight"; # Define your hostname.
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
################################################
###                                          ###
### VIRTUALISATION                           ###
###                                          ###
################################################
  #virtualisation = {
  #vmware.host.enable = true;
  #virtualbox.host.enable = true;
  #virtualbox.host.enableExtensionPack = true;
  #};
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/414ec555-9de5-4c46-983b-fea85995ede4";
    fsType = "ext4";  
    options = [ "defaults" "noatime" "discard" ];  # SSD optimizations
  };
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  # Set your time zone.
  time.timeZone = "Europe/Tallinn";



################################################
###                                          ###
### TAILSCALE                                ###
###                                          ###
################################################
  services.tailscale.enable = true;
  
#  # EXIT NODE SETUP
#  boot.kernel.sysctl = {
#    "net.ipv4.ip_forward" = 1;
#    "net.ipv6.conf.all.forwarding" = 1;
#  };
# 
#  systemd.services.enable-udp-gro = {
#    description = "Enable UDP GRO forwarding";
#    wantedBy = [ "multi-user.target" ];
#    after = [ "network.target" ];
#    path = with pkgs; [ iproute2 ethtool coreutils ]; 
#    script = ''
#      NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
#      ${pkgs.ethtool}/bin/ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off
#       '';
#    serviceConfig = {
#      Type = "oneshot";
#    };
#  };
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "taila96b3.ts.net" ];

############################################################################
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "et_EE.UTF-8";
    LC_IDENTIFICATION = "et_EE.UTF-8";
    LC_MEASUREMENT = "et_EE.UTF-8";
    LC_MONETARY = "et_EE.UTF-8";
    LC_NAME = "et_EE.UTF-8";
    LC_NUMERIC = "et_EE.UTF-8";
    LC_PAPER = "et_EE.UTF-8";
    LC_TELEPHONE = "et_EE.UTF-8";
    LC_TIME = "et_EE.UTF-8";
  };


################################################
###                                          ###
### WAYLAND/HYPERLAND                        ###
###                                          ###
################################################
  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  #services.gnome.gnome-keyring.enable = true;
  #services.dbus.enable = true;
  #services.xserver.enable = false;  # Disable X11 if not needed
  #services.displayManager.sddm.enable = false;  # If not using SDDM
  # services.displayManager.sessionPackages = [ pkgs.hyprland ];
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true; 
  # };
  # environment.sessionVariables = {
  #   NIXOS_OZONE_WL = "1";  # Fixes Electron apps
  #   QT_QPA_PLATFORM = "wayland";
  #   SDL_VIDEODRIVER = "wayland";
  # };
  #hardware = {
  #  graphics.enable = true;
  #};
  # services.xserver.libinput = {
  # enable = true;
  # touchpad.naturalScrolling = true;  # Optional for touchpads
  # };

  #XDG portal
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
################################################
###                                          ###
### Performance Improvement and tweaking     ###
###                                          ###
################################################
  #services.thermald.enable = true;
  #powerManagement.cpuFreqGovernor = "performance";
################################################
###                                          ###
### WINDOW MANAGER SETTINGS/WAYLAND/X11      ###
###                                          ###
################################################

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  
  #Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.displayManager.defaultSession = "xfce";
  #Configure keymap in X11
  services.xserver = {
   xkb.layout = "us";
   xkb.variant = "";
  };

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "ahmed";
###############################################

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # use the intel/nvidia driver
  services.xserver.videoDrivers = [ "intel" ];
  # rsyslog
  services.rsyslogd.enable = true;
  #services.journald.extraConfig = "ForwardToSyslog=yes";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ahmed = {
    isNormalUser = true;
    description = "ahmed";
    extraGroups = [ "vboxusers" "networkmanager" "wheel" "video" "input" "seat" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };
  security.sudo.extraRules= [
    {  users = [ "ahmed" ];
      commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Allow unfree and unstable packages 
  nixpkgs = {
    config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
      };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    #firefox
    #openfortivpn
    #vscode
    #git
    #gh #use gh auth login
    #fzf
    #popsicle
    #nethogs
    #flatpak #to install brave or other progs not supported in nixos
    #gnome-software # installation GUI
    #htop
    #vlc
    #ranger
    #tmux
    #gparted
    #mlocate
    #rar
    #teams-for-linux
    #virtualbox
    #tree
    ######################################################
    #nmap
    #openvpn
    #exploitdb
    #metasploit
    #seclists
    #gobuster
    #whatweb
    #eyewitness 
    #######################################################
    #neofetch
    #vault
    ##tailscale-systray
    ##heimdall-gui
    ##onlyoffice-desktopeditors
    #docker_28
    #qdigidoc
    ##tigervnc
    ##pciutils
    #ansible
    ##sshpass
    #unzip
    #traceroute
    #ansible-lint
    # user
    #starship
    #simplescreenrecorder
    #openfortivpn-webview
    ##discord
    ##telegram-desktop
    #qbittorrent
    #mendeley
    #calibre
    #qFlipper
    ##antigravity
    #flameshot
    ##solaar
    #bitwarden-cli
    #dysk #df but better
    #tldr
    #tlrc # tldr in rust   
    ##heimdall-gui
    ##heimdall
    #logiops
    #rpi-imager
    #ethtool
    #bandwhich
    ##tailscale GUI
    ##ktailctl
    ## Install with flatpak
    ##bitwarden-desktop
    ##onlyoffice
    ##msteams
    ##brave
  ];
 
  nixpkgs.config.permittedInsecurePackages = [
      "electron-19.1.9"
  ];
  
  users.defaultUserShell = pkgs.zsh;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.flatpak.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    #autosuggestion.enable = true;
    #syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lart";
      history="history 0";
      update = "sudo nixos-rebuild switch --flake /etc/nixos/#default";
      config= "sudo vim /etc/nixos/configuration.nix";
      ap="ansible-playbook -e \"ansible_user=ahmedn\" --ssh-common-args='-o ForwardAgent=yes -o ProxyCommand=\"ssh -W %h:%p base\"'";
      vpn="bash /home/ahmed/vpn";
      tailup="sudo tailscale up";
      taildown="sudo tailscale down";
    };
    #ohMyZsh = {
    #    enable = true;
        #plugins = [ "git" 
        #           "zsh-autosuggestions"
        #           "zsh-completions"
        #           "zsh-fzf-history-search" 
        #           "zsh-history-substring-search" 
        #];
    #};
  };   
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.extraHosts =
   ''
     <IP> <Domain>
     <IP> <Domain>
   '';

  nixpkgs.config.packageOverrides = pkgs: {
   nss-cacert = pkgs.nss-cacert.override {extraCertificates = ["/home/ahmed/.ssh/roots_hpclocal.pem"];};
  }; 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
