{ self, ... }: {
  flake.nixosModules.libvirt = { pkgs, ... }: let
    virsh = "${pkgs.libvirt}/bin/virsh";

    natNetXml = pkgs.writeText "libvirt-nat-net.xml" ''
      <network>
        <name>nat-net</name>
        <forward mode='nat'>
          <nat>
            <port start='1024' end='65535'/>
          </nat>
        </forward>
        <bridge name='libvirt-n' stp='on' delay='0'/>
        <ip address='192.168.100.1' netmask='255.255.255.0'>
          <dhcp>
            <range start='192.168.100.2' end='192.168.100.254'/>
          </dhcp>
        </ip>
      </network>
    '';

    hostOnlyXml = pkgs.writeText "libvirt-host-only.xml" ''
      <network>
        <name>host-only</name>
        <bridge name='libvirt-ho' stp='on' delay='0'/>
        <ip address='192.168.200.1' netmask='255.255.255.0'>
          <dhcp>
            <range start='192.168.200.2' end='192.168.200.254'/>
          </dhcp>
        </ip>
      </network>
    '';
  in {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package      = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };

    programs.virt-manager.enable = true;

    # Allow traffic on both bridge interfaces through the firewall
    networking.firewall.trustedInterfaces = [ "virbr10" "virbr11" ];

    # Define and start both networks once libvirtd is up
    systemd.services.libvirt-networks = {
      description     = "Define libvirt NAT and host-only networks";
      wantedBy        = [ "multi-user.target" ];
      after           = [ "libvirtd.service" ];
      requires        = [ "libvirtd.service" ];
      serviceConfig = {
        Type             = "oneshot";
        RemainAfterExit  = true;
      };
      script = ''
        define_net() {
          local name="$1" xml="$2"
          if ! ${virsh} net-info "$name" &>/dev/null; then
            ${virsh} net-define "$xml"
            ${virsh} net-autostart "$name"
          fi
          ${virsh} net-start "$name" 2>/dev/null || true
        }

        define_net nat-net   ${natNetXml}
        define_net host-only ${hostOnlyXml}
      '';
    };
  };
}
