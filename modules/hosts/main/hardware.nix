{ self, inputs, ... }: {
	flake.nixosModules.mainHardware = { config, lib, pkgs, modulesPath, ... }: {
		imports = [ ];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;
 		
		boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
		boot.initrd.kernelModules = [ ];
		boot.kernelModules = [ ];
		boot.extraModulePackages = [ ];

		fileSystems."/" =
			{ device = "/dev/disk/by-uuid/73428abd-7991-4916-a83b-ad91fcce1b2f";
			  fsType = "ext4";
			};

		swapDevices = [ ];

		nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	};
}
