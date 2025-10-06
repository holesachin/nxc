{ config, pkgs, inputs, ... }:

let 
	dotfiles = "${config.home.homeDirectory}/dotfiles";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		alacritty = "alacritty";
		bspwm = "bspwm";
		chadwm = "chadwm";
		dunst = "dunst";
		hypr = "hypr";
		kitty = "kitty";
		mpd = "mpd";
		mpv = "mpv";
		nbfc = "nbfc";
		ncmpcpp = "ncmpcpp";
		nvim = "nvim";
		picom = "picom";
		polybar = "polybar";
		qutebrowser = "qutebrowser";
		rofi = "rofi";
		sxhkd = "sxhkd";
		sxiv = "sxiv";
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
		name = "Bibata-Modern-Amber";
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
			obs-vaapi #optional AMD hardware acceleration
			obs-gstreamer
			obs-vkcapture
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
		theme.package = pkgs.flat-remix-gtk;
		theme.name = "Flat-Remix-GTK-Grey-Darkest";

		iconTheme.package = pkgs.papirus-icon-theme;
		iconTheme.name = "Papirus";
		font.name = "ShureTechMono Nerd Font Mono";
		font.size = 11;
	};

	qt = {
		enable = true;
		platformTheme = "qtct";
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
	};

	# install packages
	home.packages = with pkgs; [
		acpi
		alacritty
		brightnessctl
		bun
		cobra-cli
		code-cursor
		dash
		dunst
		fastfetch
		gimp3
		go
		gopls
		gparted
		inputs.zen-browser.packages.${pkgs.system}.default
		kitty
		lazygit
		lazydocker
		lazyjournal
		libsForQt5.qt5ct
		libsForQt5.qtstyleplugin-kvantum
		mpc
		mpd
		mpv
		nautilus
		ncmpcpp
		networkmanagerapplet
		nil
		nixpkgs-fmt
		nodejs
		nvtopPackages.full
		nwg-displays
		pcmanfm
		pnpm
		pulsemixer
		python314
		qutebrowser
		rclone
		ripgrep
		rofi-wayland
		sqlc
		swaybg
		sxiv
		tmux
		todoist
		vscode
		waybar
		wlr-randr
		yarn
		zed-editor
	];

}
