{ self, ... }: {
  flake.nixosModules.claude = { pkgs, lib, ... }: let
    # rtk is a filtering proxy: it re-runs a command and compresses the output
    # (git status, ls, cargo test, pytest, ...) before it reaches the model.
    # Claude Code drives it through a PreToolUse hook that rewrites the Bash
    # tool's command in place — `git status` becomes `rtk git status`.
    #
    # The hook binary is referenced by absolute store path because hooks run in
    # whatever environment Claude Code spawns them in, which is not guaranteed
    # to carry the system PATH.
    managedSettings = {
      hooks.PreToolUse = [{
        matcher = "Bash";
        hooks = [{
          type    = "command";
          command = "${lib.getExe pkgs.rtk} hook claude";
        }];
      }];
    };
  in {
    # rtk must be on the interactive PATH too, not just reachable by the hook:
    # the hook only rewrites the command string, and the Bash tool then runs
    # the resulting bare `rtk ...` itself.
    environment.systemPackages = [ pkgs.rtk ];

    # /etc/claude-code/managed-settings.json is Claude Code's system-wide policy
    # file on Linux, so this applies to every user and every project with no
    # per-user setup. `hooks` is one of the list-valued keys, which merge across
    # settings levels rather than overriding — a user or project can still add
    # hooks of their own in ~/.claude/settings.json without displacing this one.
    environment.etc."claude-code/managed-settings.json".source =
      (pkgs.formats.json { }).generate "claude-managed-settings.json" managedSettings;
  };
}
