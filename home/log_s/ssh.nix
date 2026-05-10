{ ... }: {
  programs.ssh = {
    enable = true;

    matchBlocks = {
      github = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}