{ config, pkgs, inputs, ... }:

let 
	dotfiles = "${config.home.homeDirectory}/dotfiles";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		alacritty = "alacritty";
		hypr = "hypr";
		kitty = "kitty";
		foot = "foot";
		mako = "mako";
		mpd = "mpd";
		mpv = "mpv";
		nbfc = "nbfc";
		ncmpcpp = "ncmpcpp";
		nvim = "nvim";
		picom = "picom";
		qutebrowser = "qutebrowser";
		rofi = "rofi";
		sxiv = "sxiv";
		lf = "lf";
		tmux = "tmux";
		waybar = "waybar";
	};
in

	{

	home.username = "sachin";
	home.homeDirectory = "/home/sachin";
	home.stateVersion = "25.05";
	programs.home-manager.enable = true;

	programs.bash = {
		enable = true;
		shellAliases = {
			vim = "nvim";
			nixup = "sudo nixos-rebuild switch --impure --flake ~/nxc#nixos";
			hmup = "home-manager switch --flake ~/nxc#sachin";
		};
	};

	programs.git = {
		enable = true;
		userName = "holesachin";
		userEmail = "holesachin007@gmail.com";
	};

	home.pointerCursor = {
		gtk.enable = true;
		x11.enable = true;
		package = pkgs.bibata-cursors;
		name = "Bibata-Modern-Ice";
		size = 10;
	};

	programs.obs-studio = {
		enable = true;
		package = ( pkgs.obs-studio.override {
			cudaSupport = true;
		});
		plugins = with pkgs.obs-studio-plugins; [
			wlrobs
			obs-backgroundremoval
			obs-pipewire-audio-capture
			obs-vaapi
			obs-gstreamer
			obs-vkcapture
			waveform
			droidcam-obs
		];
	};

	programs.distrobox.enable = true;
	# programs.distrobox.containers = {
	# 	ubuntu = {
	# 		entry = true;
	# 		image = "ubuntu:latest";
	# 	};
	# };

	gtk = {
		enable = true;
		theme.package = pkgs.dracula-theme;
		theme.name = "Dracula";

		iconTheme.package = pkgs.papirus-icon-theme;
		iconTheme.name = "Papirus-Dark";
		font.name = "ShureTechMono Nerd Font Mono";
		font.size = 11;
	};

	qt = {
		enable = true;
		platformTheme.name = "qtct";
		style = {
			package = pkgs.rose-pine-kvantum;
			name = "kvantum";
		};
	};

	# links configs to ~/.config
	xdg.configFile = builtins.mapAttrs ( name: subpath: {
		source = create_symlink "${dotfiles}/${subpath}";
		recursive = true;
	}) configs;

	home.file = {
		".zshrc".source = create_symlink "${dotfiles}/zsh/zshrc";
		".xinitrc".source = create_symlink "${dotfiles}/xorg/xinitrc";
		".config/user-dirs.dirs".source = create_symlink "${dotfiles}/xdg/user-dirs.dirs";
		".local/scripts".source = create_symlink "${dotfiles}/scripts";
	};

	services.ollama = {
		enable = true;
		host = "[::]";
		acceleration = "cuda";
	};

	# install packages
	home.packages = with pkgs; [
		acpi
		alacritty
		arduino-cli
		arduino-ide
		audacity
		android-studio
		bitwarden-cli
		brave
		brightnessctl
		bun
		cobra-cli
		code-cursor
		dash
		fastfetch
		foot
		gimp3
		go
		gowall
		gparted
		hyprshot
		hyprpaper
		imagemagick
		imagemagick
		inputs.zen-browser.packages.${pkgs.system}.default
		kitty
		lazydocker
		lazygit
		lazyjournal
		lf
		libsForQt5.qt5ct
		libsForQt5.qtstyleplugin-kvantum
		love
		lua
		lua53Packages.luarocks
		mako
		mpc
		mpd
		mpv
		trash-cli
		nats-top
		natscli
		nautilus
		ncmpcpp
		networkmanagerapplet
		nil
		nixpkgs-fmt
		nodejs
		nvtopPackages.full
		nwg-displays
		nwg-look
		obsidian
		pcmanfm
		pnpm
		pulsemixer
		python314
		qutebrowser
		rclone
		ripgrep
		rofi-wayland
		scrcpy
		sqlc
		swaybg
		sxiv
		tmate
		tmux
		todoist
		vscode
		wails
		waybar
		whisper-cpp
		wlr-randr
		yarn
		yt-dlp
		ytfzf
		zed-editor
	];

}
