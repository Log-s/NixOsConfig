{ ... }: {
  programs.git = {
    enable = true;

    userName = "Log_s";
    userEmail = "leo951206@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}