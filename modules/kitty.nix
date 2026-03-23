{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };

    settings = {
      working_directory = "~";

      # Prevent multiple instances lingering in dock on macOS
      macos_quit_when_last_window_closed = "yes";

      # Hide tabs and window decorations for a clean, tmux-driven experience
      tab_bar_style = "hidden";
      hide_window_decorations = "titlebar-only";

      # Make Option act as Alt (common requirement for CLI tools)
      macos_option_as_alt = "yes";
    
      # Remove internal padding so tmux can use the full space
      window_padding_width = 0;

    };

    keybindings = {
      # Unbind Kitty's native window/tab management to rely purely on tmux
      "cmd+t" = "no_op";
      "cmd+n" = "no_op";
      "cmd+w" = "no_op";
      "cmd+enter" = "no_op";
      
      "ctrl+shift+t" = "no_op";
      "ctrl+shift+n" = "no_op";
      "ctrl+shift+w" = "no_op";
      "ctrl+shift+enter" = "no_op";

      # Explicitly send the standardized modifyOtherKeys sequence for Ctrl+Enter
      # This bypasses tmux's stripping logic and guarantees ble.sh receives it reliably.
      "ctrl+enter" = "send_text all \\x1b[27;5;13~";
    };
  };
}
