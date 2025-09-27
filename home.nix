{ config, pkgs, ... }:

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
		qutebrowser = "qutebrowser";
	};
in

	{

	home.username = "sachin";
	home.homeDirectory = "/home/sachin";
	programs.git.enable = true;
	home.stateVersion = "25.05";

	programs.bash = {
		enable = true;
		shellAliases = {
			vim = "nvim";
			nxc-update = "sudo nixos-rebuild switch --impure --flake ~/nxc#nixos";
		};
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			vim = "nvim";
			nxc-update = "sudo nixos-rebuild switch --impure --flake ~/nxc#nixos";
		};
		history.size = 10000;
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
		xclip
		qutebrowser
		fastfetch
	];

}
