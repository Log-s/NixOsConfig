{ self, inputs, ... }: {
  flake.nixosConfigurations.main = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.mainConfiguration
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupCommand = "mv \"$FILE\" \"$FILE.$(date +%Y%m%d%H%M%S).backup\"";
        home-manager.extraSpecialArgs = { inherit inputs self; };
        home-manager.users.log_s = import ../../../home/log_s;
      }
    ];
  };
}
