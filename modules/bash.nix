{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    blesh
  ];

  home.file.".hushlogin".text = "";

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if [[ $- == *i* ]]; then
        if [ -z "$TMUX" ] && [ -z "$TERMINAL_EMULATOR" ] && [[ "$TERM_PROGRAM" != "vscode" ]] && command -v tmux &> /dev/null; then
          tmux
        fi

        # --attach=none defers terminal takeover until ble-attach below,
        # which must happen after starship initializes its prompt hooks.
        source -- "$(blesh-share)"/ble.sh --attach=none

        bleopt default_keymap=vi
        function my/vim-load-hook {
          # term_vi_* sends escape codes directly on mode entry
          bleopt term_vi_imap=$'\e[5 q'
          bleopt term_vi_nmap=$'\e[2 q'
          bleopt keymap_vi_mode_show=
        }
        # eval-after-load defers until the vi keymap module is ready
        blehook/eval-after-load keymap_vi my/vim-load-hook

        if [[ $TERM != "dumb" ]]; then
          eval "$(starship init bash)"
        fi

        [[ ! ''${BLE_VERSION-} ]] || ble-attach

        export SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.dylib
      fi
    '';
  };
}
