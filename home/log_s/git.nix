{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      user.name = "Log_s";
      user.email = "leo951206@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}