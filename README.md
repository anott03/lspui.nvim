# LspUI.nvim
A fairly simply frontend for neovim's builtin lsp to do things like code actions and token renaming. This project is largely inspired by [lspsaga](https://github.com/glepnir/lspsaga.nvim), and is very much a WIP.

## Installation
#### Vim-Plug
```viml
Plug 'nvim-lua/plenary.nvim' # required for lspui to work
Plug 'anott03/lspui.nvim', { 'branch': 'main' }
```
#### Packer.nvim
```lua
use {
  'anott03/lspui.nvim',
  branch = 'main',
  requires = {'nvim-lua/plenary.nvim'},
}
```
