# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./suspend_then_hibernate.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  #boot.loader.grub.useOSProber = true;
  #boot.loader.grub.theme = "${pkgs.sleek-grub-theme}/Sleek\ theme-dark";

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    enable = true;
    windowManager.i3.enable = true;
    windowManager.i3.extraPackages = with pkgs; [
	i3blocks
	];
  };

  services.displayManager = {
    enable = true;
    defaultSession = "none+i3";
    sddm = {
      enable = true;
      theme = "catppuccin-macchiato";
      package = pkgs.kdePackages.sddm;
    };
  };
  
  programs.zsh.enable = true;


  users.users.sert = {
    isNormalUser = true;
    description = "South Eugene Robotics Team";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  users.defaultUserShell = pkgs.zsh;


  home-manager.users.sert = { pkgs, ... }: {

	home.homeDirectory = "/home/sert";

#### HOME.FILE STUFF
	home.file = {
		i3blocks = {
			enable = true;
			executable = false;
			source = ./i3blocks.conf;
			target = ".config/i3blocks/config";
		};
	};


#### HOME MANAGER PACKAGES
    home.packages = with pkgs; [
      vim
      firefox
      fastfetch
      lm_sensors
      acpi
      git
      bottom
      eza
      trashy
      xcolor
      gnumake
	gcc
	nemo-with-extensions
	
    ];

#### PROGRAMS
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      initExtra = ''
	alias nixedit="sudo vim /etc/nixos/configuration.nix"
	alias nixrb="sudo nixos-rebuild switch --flake /etc/nixos#sert"
	alias ls="eza"
        alias tp="trash put"

	function tree () {
		eza -T -L $0
	}

	# keep at end
	eval "$(zoxide init zsh)"'';
      oh-my-zsh = {
	enable = true;
	theme = "steeef";	
      }; 
};
    programs.zoxide = {
	enable = true;
	enableZshIntegration = true;
    };
    programs.rofi = {
      enable = true;
      cycle = true;
      location = "center";
      extraConfig = {
        modi = "drun,window";
      };
    };


	programs.i3blocks = {
		enable = true;
		bars = {};
	};


#### SERVICES 
    services.dunst = {
	enable = true;
    };
    
#### XSESSION
    xsession.windowManager.i3 = { 
      enable = true;
      package = pkgs.i3-gaps;

#### i3 CONFIG
	config = {
		modifier = "Mod4";
		gaps = {
			inner = 7;
			outer = 5;
        	};
		keybindings = lib.mkOptionDefault {
			"Mod4+r" = "exec sh -c '${pkgs.rofi}/bin/rofi -show drun'";
			"Mod4+q" = "restart";
			"Mod4+Shift+q" = "exit";
			"Mod4+Shift+c" = "kill";
			"Mod4+Shift+r" = "mode resize";
        	};
		bars = [
			{
				position = "top";
				statusCommand = "i3blocks";
				trayOutput = "primary";
				colors.background = "#16161e";
			}
		];
      };



    };
  
#### STYLIX
  stylix.enable = true;
  stylix.image = ./wallpaper.jpg; 
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";

    # Override scheme to prevent bad terminal colors
  stylix.override = {};
  stylix.fonts = {
    serif = { package = pkgs.dejavu_fonts; name = "DejaVu Serif";};
    sansSerif = { package = pkgs.ubuntu_font_family; name = "Ubuntu Regular"; };
    monospace = { package = pkgs.hack-font; name = "Hack Regular"; };
    emoji = { package = pkgs.noto-fonts-emoji; name = "Noto Color Emoji"; };
  };
	home.stateVersion = "24.05";
	


  };

# end home-manager section 
  stylix.enable = true;
  stylix.image = ./wallpaper.jpg; 
  stylix.fonts = {
    serif = { package = pkgs.dejavu_fonts; name = "DejaVu Serif";};
    sansSerif = { package = pkgs.ubuntu_font_family; name = "Ubuntu Regular"; };
    monospace = { package = pkgs.hack-font; name = "Hack Regular"; };
    emoji = { package = pkgs.noto-fonts-emoji; name = "Noto Color Emoji"; };
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  nix.settings.experimental-features = ["flakes" "nix-command"];
  environment.pathsToLink = [ "/share/zsh" "/libexec"];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    jetbrains-toolbox
    vscode
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
	services.openssh.enable = true;
	services.tlp = {
		enable = true;
		settings = {};
	};
	services.upower.enable = true;
	programs.coolercontrol.enable = true;
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

	swapDevices = [{
		device = "/swapfile";
		size = 10 * 1024;
	}];


  fileSystems = {
  "/mnt/usb" = {
    device = "/dev/sdb";
    fsType = "vfat";
    options = [
      "users"
      "nofail"
      "exec"
      "x-gvfs-show"
      ];
    };
  };
}
