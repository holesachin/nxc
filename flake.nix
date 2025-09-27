{
	description = "NixOS with Home Manager";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.05";
		home-manager.url = "github:nix-community/home-manager/release-25.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, ... }:
		{
			nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./configuration.nix
					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.sachin = import ./home.nix;
						home-manager.backupFileExtension = "backup";
					}
				];
			};
		};
}

