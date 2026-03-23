{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    settings = {
      add_newline = false;
      # Non used formatters are disabled implicitly.
      format = "$directory$git_branch$git_status$line_break$character";

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
