{
	description = "NixOS with Home Manager";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.05";
		zen-browser.url = "github:0xc000022070/zen-browser-flake";
		home-manager.url = "github:nix-community/home-manager/release-25.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, zen-browser, ... } @ inputs:

	let
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in {

		# Nixos system config
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = { inherit inputs; };
			modules = [ 
				./configuration.nix
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.sachin = import ./home.nix;
					home-manager.backupFileExtension = "backup";
					home-manager.extraSpecialArgs = { inherit inputs;  };
				}
			];
		};

		# Home Manager config
		# homeConfigurations.sachin = home-manager.lib.homeManagerConfiguration {
		# 	inherit pkgs;
		# 	modules = [ ./home.nix ];
		# 	extraSpecialArgs = { inherit inputs; };
		# };

	};
}
