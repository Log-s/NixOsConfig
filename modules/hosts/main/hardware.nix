{ self, inputs, ... }: {
	flake.nixosModules.mainHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.initrd.availableKernelModules = [
      "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
    ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-intel" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];

    # ── NVIDIA driver ─────────────────────────────────────────────────────
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;            # proprietary driver (Turing/Quadro T1000)
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;   # adds `nvidia-offload` wrapper
      };
      intelBusId  = "PCI:0:2:0";  # FIXME
      nvidiaBusId = "PCI:1:0:0";  # FIXME
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    # ── Filesystems ───────────────────────────────────────────────────────
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID"; # FIXME
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-EFI-UUID"; # FIXME
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
