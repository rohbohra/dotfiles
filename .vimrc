set relativenumber
set tabstop=4       " width of a tab character
set shiftwidth=4    " indentation width (>, <, ==)
set expandtab       " insert spaces instead of tabs
set softtabstop=4   " spaces inserted/deleted when pressing Tab/Backspace


call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

if executable('rust-analyzer')
    function! s:register_rust_lsp()
        call lsp#register_server({
            \ 'name': 'rust-analyzer',
            \ 'cmd': ['rust-analyzer'],
            \ 'allowlist': ['rust'],
            \ 'blocklist': [],
            \ 'config': {},
            \ 'workspace_config': {
            \   'rust-analyzer': {
            \     'cargo': {'allFeatures': v:true},
            \     'checkOnSave': {'command': 'clippy'},
            \   }
            \ }
            \ })
    endfunction

    augroup LspRust
        autocmd!
        autocmd User lsp_setup call s:register_rust_lsp()
        autocmd FileType rust nnoremap <buffer> gd :LspDefinition<CR>
        autocmd FileType rust nnoremap <buffer> gr :LspReferences<CR>
        autocmd FileType rust nnoremap <buffer> K :LspHover<CR>
        autocmd FileType rust nnoremap <buffer> <leader>cr :LspRename<CR>
    augroup end
endif

