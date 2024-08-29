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
  boot.loader.grub.efiSupport = true;


  networking.hostName = "nixos"; # Define your hostname.

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
    displayManager.gdm.enable = true;
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
	appimage-run
	
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

#### SYSTEMWIDE INSTALLATIONS (PUT UNFREE PACKAGES HERE)
  environment.systemPackages = with pkgs; [
    jetbrains-toolbox
    vscode
  ];


#### SYSTEMWIDE SERVICES
	services.openssh.enable = true;
	services.tlp = {
		enable = true;
		settings = {};
	};
	services.upower.enable = true;
	programs.coolercontrol.enable = true;


  	system.stateVersion = "24.05"; # Do not change this

	swapDevices = [{
		device = "/swapfile";
		size = # MUST BE ADDED BEFORE REBUILD ( cat /proc/meminfo for memory information )
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
