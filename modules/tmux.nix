{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.bash}/bin/bash";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    extraConfig = ''
      # split panes using | and - (more intuitive than " and %)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Allow ble.sh to query Kitty's capabilities through tmux
      set -g allow-passthrough on
      # Force tmux to request extended keys from the terminal and pass them to applications
      set -s extended-keys always

      # Teach tmux how to translate cursor shape requests (ANSI ESC[N q) into
      # sequences the outer terminal (Kitty) understands. Without Ss/Se, tmux
      # silently drops cursor-shape changes from ble.sh, causing the invisible
      # cursor. Ss sets the shape, Se resets it to the terminal default.
      set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
    '';
  };
}
