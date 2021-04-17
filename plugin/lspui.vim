if !has('nvim')
    echohl Error
    echom "This plugin only supports nvim version 0.5+"
    echohl clear
    finish
endif

highlight default link LspuiNormal Normal
highlight default LspuiBorder guifg=lightblue
highlight default LspuiTitle guifg=orange
