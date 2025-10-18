{ config, pkgs, ... }: 
let
	user = "sachin";
in
	{
	imports = [
		/etc/nixos/hardware-configuration.nix
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.systemd-boot.configurationLimit = 7;
	boot.kernelPackages = pkgs.linuxPackages_6_16;
	# boot.kernelPackages = pkgs.linuxPackages_zen;

	# CPU & GPU Drivers
	hardware.cpu.amd.updateMicrocode = true;
	hardware.graphics.enable = true;
	hardware.graphics.enable32Bit = true;

	hardware.enableAllFirmware = true;
	hardware.bluetooth.enable = true;

	# Load NVIDIA proprietary drivers
	hardware.nvidia = {
		open = false;                              # Use proprietary NVIDIA drivers instead of open-source nouveau
		modesetting.enable = true;                 # Enable kernel modesetting for better Wayland compatibility
		powerManagement.enable = true;             # Enable power management features (important for laptops)
		powerManagement.finegrained = true;        # Enable fine-grained power management for more aggressive power saving
		nvidiaPersistenced = true;                 # Keep GPU initialized even when no processes are using it
		videoAcceleration = true;                  # Enable video acceleration support (VA-API, VDPAU)
		gsp.enable = true;                         # Use GPU System Processor firmware for newer GPUs (better performance)
		nvidiaSettings = true;                     # Install nvidia-settings GUI application
		package = config.boot.kernelPackages.nvidiaPackages.stable; # Use the stable version of NVIDIA drivers
	};

	# Hybrid GPU
	hardware.nvidia.prime = {
		offload.enable = true;
		offload.enableOffloadCmd = true;
		amdgpuBusId = "PCI:06:00:0";
		nvidiaBusId = "PCI:01:00:0";
	};

	nix.optimise.automatic = true;
	nix.optimise.dates = [ "weekly" ];
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

	services.thermald.enable = true;
	services.auto-cpufreq.enable = true;

	programs.virt-manager.enable = true;
	users.groups.libvirtd.members = [ "${user}" ];
	virtualisation.libvirtd.enable = true;
	virtualisation.spiceUSBRedirection.enable = true;

	## ---

	networking.hostName = "nixos";
	networking.networkmanager.enable = true;
	networking.networkmanager.wifi.powersave = true;
	networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
	# networking.extraHosts = ''
	# '';

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

	# Define a user account
	users.users.sachin = {
		isNormalUser = true;
		description = "my nixos!";
		extraGroups = [ "networkmanager" "wheel" "docker" ];
		shell = pkgs.zsh;
	};

	programs.zsh.enable = true;

	xdg.portal.enable = true;
	xdg.portal.config.common.default = "hyprland";
	xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

	environment.sessionVariables = { 
		__NV_PRIME_RENDER_OFFLOAD = 1;
		__NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
		__GLX_VENDOR_LIBRARY_NAME = "nvidia";
		__VK_LAYER_NV_optimus = "NVIDIA_only";
		DRI_PRIME = 1;
	};

	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	# enable greetd and auto login
	services.greetd.enable = true;
	services.greetd.settings = {
		default_session = {
			command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.bashInteractive}/bin/bash";
			user = "${user}";
		};
		initial_session = {
			command = "${pkgs.hyprland}/bin/Hyprland";
			user = "${user}";
		};
	};

	# xorg
	services.xserver.enable = true;
	services.xserver.autorun = false;
	services.xserver.videoDrivers = [ 
		"nvidia"
		"amdgpu"
	];

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
	};

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

	# Docker
	virtualisation.docker.enable = true;
	virtualisation.docker.rootless = {
		enable = true;
		setSocketVariable = true;
	};

	# Install Programs
	programs.firefox.enable = true;

	# Polkit
	security.polkit.enable = true;

	# Enable Appimage Support
	programs.appimage.enable = true;
	programs.appimage.binfmt = true;

	#
	programs.obs-studio.enableVirtualCamera = true;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Enable experimental features
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# fonts
	fonts.packages = with pkgs; [
		comic-mono
		jetbrains-mono
		meslo-lg
		nerd-fonts.comic-shanns-mono
		nerd-fonts.jetbrains-mono
		nerd-fonts.meslo-lg
		nerd-fonts.monaspace
		nerd-fonts.shure-tech-mono
	];

	# List packages installed in system profile. To search, run:
	environment.systemPackages = with pkgs; [
		cmd-polkit
		curl
		dconf
		ffmpeg
		fzf
		gcc
		git
		gnumake
		htop
		hyprlock
		jq
		libsForQt5.qt5.qtgraphicaleffects
		libsForQt5.qt5.qtquickcontrols
		nbfc-linux
		neovim
		unzip
		wget
		zip
	];

	# NBFC Config
	environment.etc."nbfc/nbfc.json".text = builtins.toJSON {
		SelectedConfigId = "HP Victus 15-fb0xxx";
	};

	# Enable NBFC
	systemd.services.nbfc_service = {
		enable = true;
		description = "Fan Controll HP Victus 15-fb0xxx";
		serviceConfig.Type = "simple";
		path = [pkgs.kmod];
		# script = "${pkgs.nbfc-linux}/bin/nbfc_service --config-file /home/sachin/.config/nbfc/nbfc.json";
		script = "${pkgs.nbfc-linux}/bin/nbfc_service --config-file /etc/nbfc/nbfc.json";
		wantedBy = ["multi-user.target"];
	};

	# Tailscale
	services.tailscale.enable = true;

	# Bluetoot
	services.blueman.enable = true;

	# Enable touchpad support (enabled default in most desktopManager).
	services.libinput.enable = true;

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

	system.stateVersion = "25.05";
}
