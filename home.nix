{config, pkgs, inputs, ... }:

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
		nbfc = "nbfc";
		sxiv = "sxiv";
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
		size = 16;
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

	# install packages
	home.packages = with pkgs; [
		alacritty
		kitty
		sxhkd
		tmux
		polybar
		rofi
		dmenu
		tmux
		nodejs
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
		swaybg
		obs-studio
		qutebrowser
		fastfetch
		nwg-displays
		nwg-look
		wlr-randr
		nvtopPackages.full
		networkmanagerapplet
		inputs.zen-browser.packages.${pkgs.system}.default
		inputs.home-manager.packages.${pkgs.system}.home-manager
	];

}
