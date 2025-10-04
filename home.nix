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
		bspwm
		bun
		code-cursor
		dash
		dmenu
		dunst
		eww
		fastfetch
		feh
		gimp3
		go
		gopls
		gparted
		inputs.zen-browser.packages.${pkgs.system}.default
		kitty
		mpc
		mpd
		mpv
		ncmpcpp
		nautilus
		networkmanagerapplet
		nil
		nixpkgs-fmt
		nodejs
		nvtopPackages.full
		nwg-displays
		obs-studio
		pcmanfm
		picom
		pulsemixer
		pnpm
		polybar
		pulsemixer
		qutebrowser
		rclone
		ripgrep
		rofi
		swaybg
		sxhkd
		sxiv
		tmux
		tmux
		vscode
		waybar
		wlr-randr
		xclip
		xorg.xinit
		xorg.xrandr
		yarn
		zed-editor
	];

}
