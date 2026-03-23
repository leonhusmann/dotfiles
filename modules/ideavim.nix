{ config, pkgs, ... }:

{
  home.file.".ideavimrc".text = ''
    source ~/.vimrc
    
    set scrolloff=5
    set incsearch
    map Q gq
    
    Plug 'machakann/vim-highlightedyank'
    Plug 'tpope/vim-commentary'

    set relativenumber number

    set clipboard=unnamed
    set clipboard^=ideaput
  '';
}
