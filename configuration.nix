{ config, pkgs, ... }:

{
	imports = [
		/etc/nixos/hardware-configuration.nix
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.systemd-boot.configurationLimit = 11;

	# CPU & GPU Drivers
	hardware.cpu.amd.updateMicrocode = true;
	hardware.graphics.enable = true;
	hardware.graphics.enable32Bit = true;
	hardware.nvidia.open = true;
	hardware.nvidia.modesetting.enable = true;
	hardware.nvidia.nvidiaSettings = true;
	hardware.nvidia.prime.sync.enable = true;
	hardware.nvidia.prime.nvidiaBusId = "PCI:1@0:0:0";
	hardware.nvidia.prime.amdgpuBusId = "PCI:4@0:0:0";
	hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

	nix.optimise.automatic = true;
	nix.optimise.dates = [ "weekly" ];
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

	## ---

	networking.hostName = "nixos";
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "Asia/Kolkata";

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

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.sachin = {
		isNormalUser = true;
		description = "Sachin Adinath Hole";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [];
	};

	# hyprland
	programs.hyprland = {
		enable = true;
		withUWSM = true;
		xwayland.enable = true;
	};

	# niri
	programs.niri.enable = true;

	xdg.portal.enable = true;
	xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;

	# xorg
	services.xserver.enable = true;
	services.xserver.windowManager.bspwm.enable = true;
	services.xserver.videoDrivers = [
		"modesetting"
		"nvidia"
	];

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	# Enable sound with pipewire.
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		wireplumber.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	# fonts
	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
		nerd-fonts.shure-tech-mono
		nerd-fonts.comic-shanns-mono
		nerd-fonts.monaspace
	];

	# Install Programs
	programs.firefox.enable = true;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Enable experimental features
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# List packages installed in system profile. To search, run:
	environment.systemPackages = with pkgs; [
		neovim
		gcc
		wget
		htop
		fzf
		zip
		unzip
		curl
	];

	# Enable touchpad support (enabled default in most desktopManager).
	services.libinput.enable = true;

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

	system.stateVersion = "25.05";
}
