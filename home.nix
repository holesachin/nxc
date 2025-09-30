{ config, pkgs, inputs, ... }:

let 
	dotfiles = "${config.home.homeDirectory}/dotfiles";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		hypr = "hypr";
		kitty = "kitty";
		alacritty = "alacritty";
		nvim = "nvim";
		bspwm = "bspwm";
		sxhkd = "sxhkd";
		rofi = "rofi";
		tmux = "tmux";
		polybar = "polybar";
		waybar = "waybar";
		dunst = "dunst";
		nbfc = "nbfc";
		sxiv = "sxiv";
		mpv = "mpv";
		mpd = "mpd";
		ncmpcpp = "ncmpcpp";
		qutebrowser = "qutebrowser";
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
	programs.distrobox.containers = {
		ubuntu = {
			entry = true;
			image = "ubuntu:latest";
		};
	};

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
		".config/user-dirs.dirs".source = create_symlink "${dotfiles}/xdg/user-dirs.dirs";
	};

	# install packages
	home.packages = with pkgs; [
		alacritty
		kitty
		bspwm
		sxhkd
		tmux
		polybar
		rofi
		dmenu
		tmux
		nodejs
		bun
		go
		gopls
		yarn
		pnpm
		ripgrep
		nil
		nixpkgs-fmt
		xorg.xrandr
		xorg.xinit
		xclip
		sxiv
		pcmanfm
		brightnessctl
		pulsemixer
		zed-editor
		code-cursor
		vscode
		mpd
		mpc
		gimp3
		ncmpcpp
		mpv
		swaybg
		obs-studio
		dunst
		waybar
		qutebrowser
		fastfetch
		nwg-displays
		wlr-randr
		nvtopPackages.full
		networkmanagerapplet
		inputs.zen-browser.packages.${pkgs.system}.default
	];

}
