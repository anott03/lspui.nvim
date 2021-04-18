# LspUI.nvim
A fairly simply frontend for neovim's builtin lsp to do things like code actions and token renaming. Please note that this project is very much a WIP, and things will likely break or change.

This project is largely inspired by [lspsaga](https://github.com/glepnir/lspsaga.nvim).

## Installation
#### Vim-Plug
```viml
Plug 'nvim-lua/plenary.nvim' " required for lspui to work
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

## Usage
Currently all functionality must be called with lua.
#### Code Actions
```lua
require('lspui.code_actions').action_picker()
```
As a keybinding it might look something like this:
```vim
<nnoremap> <leader>a lua require('lspui.code_actions').action_picker()<CR>
```
#### Line Diagnostics
```lua
require('lspui.hover').line_diagnostics()
```
#### Hover Docs
```lua
require('lspui.hover').hover_doc()
```
