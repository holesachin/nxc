{ config, pkgs, inputs, ... }:

let 
	dotfiles = "${config.home.homeDirectory}/dotfiles";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		kitty = "kitty";
		alacritty = "alacritty";
		nvim = "nvim";
		bspwm = "bspwm";
		sxhkd = "sxhkd";
		rofi = "rofi";
		tmux = "tmux";
		polybar = "polybar";
		nbfc = "nbfc";
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
			nxc-update = "sudo nixos-rebuild switch --impure --flake ~/nxc#nixos";
		};
	};

	programs.zsh = {
		enable = true;
	};

	programs.git = {
		enable = true;
		userName = "holesachin";
		userEmail = "holesachin007@gmail.com";
	};

	programs.fzf.enableZshIntegration = true;

	home.pointerCursor = {
		gtk.enable = true;
		# x11.enable = true;
		package = pkgs.bibata-cursors;
		name = "Bibata-Modern-Classic";
		size = 16;
	};

	gtk.enable = true;
	gtk.theme = {
		package = pkgs.flat-remix-gtk;
		name = "Flat-Remix-GTK-Grey-Darkest";
	};
	gtk.iconTheme = {
		package = pkgs.adwaita-icon-theme;
		name = "Adwaita";
	};
	gtk.font = {
		name = "Sans";
		size = 11;
	};

	# links configs to ~/.config
	xdg.configFile = builtins.mapAttrs ( name: subpath: {
		source = create_symlink "${dotfiles}/${subpath}";
		recursive = true;
	}) configs;

	# install packages
	home.packages = with pkgs; [
		alacritty
		kitty
		bspwm
		sxhkd
		polybar
		rofi
		tmux
		nodejs
		ripgrep
		nil
		nixpkgs-fmt
		xorg.xrandr
		xorg.xinit
		xclip
		qutebrowser
		fastfetch
		nvtopPackages.full
		networkmanagerapplet
		inputs.zen-browser.packages.${pkgs.system}.default
		inputs.home-manager.packages.${pkgs.system}.home-manager
	];

}
