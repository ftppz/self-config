setlocal noswapfile " Do not create swap files
set bufhidden=hide " Hide buffer when abandoned
set number " Show line numbers
" set cursorline " Highlight the current line
set ruler " Show ruler in status line
set shiftwidth=4 " Indent width for << and >>
set softtabstop=4 " Backspace removes 4 spaces at once
set tabstop=4 " Display tab width as 4 spaces
set nobackup " Do not create backup when overwriting
set autochdir " Auto-change cwd to current file's directory
set backupcopy=yes " Overwrite file directly when backing up
set hlsearch " Highlight search matches
set noerrorbells " Disable error bells
set novisualbell " Disable visual bell
set t_vb= " Clear terminal visual bell code
set matchtime=2 " Briefly jump to matching bracket
set magic " Enable magic pattern mode
set smartindent " Enable smart auto-indent on new line
set backspace=indent,eol,start " Allow backspace/delete over indent, EOL, and start
set cmdheight=1 " Command line height
set laststatus=2 " Always show status line
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%) " Status line content
set foldenable " Enable folding
set foldmethod=syntax " Use syntax-based folding
set foldcolumn=1 " Fold column width
setlocal foldlevel=0 " Initial fold level
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> " Toggle fold with space

" for in vim visual mode, quick copy to codex-cli
xnoremap <leader>as :<C-u>call system("tmux load-buffer -", @@) \| call system("tmux paste-buffer -t '{left}' -d") \| call system("tmux select-pane -L")<CR>


call plug#begin('~/.vim/plugged')
" Enhanced Python syntax highlighting
Plug 'vim-python/python-syntax'

" General LSP/completion support (requires Node.js)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Auto-formatting (optional)
Plug 'psf/black', { 'branch': 'stable' }

" CMake integration tool ---
Plug 'cdelledonne/vim-cmake'

" --- Extra: improved C/C++ syntax highlighting ---
Plug 'bfrg/vim-cpp-modern'

" --- Extra: file tree (optional, useful for project navigation) ---
Plug 'preservim/nerdtree'

" 
Plug 'luochen1990/rainbow'


" Dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" Recommended python-syntax setting
let g:python_highlight_all = 1
colorscheme dracula

" --- vim-cmake configuration ---
" Use F4 to toggle the CMake console
nnoremap <F4> :CMake<CR>
" Use F5 to generate build directory and build (similar to cmake .. && make)
nnoremap <F5> :CMakeGenerate<CR>:CMakeBuild<CR>
" --- coc.nvim key mappings ---
" Use Tab to navigate completion items
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Enter confirms completion
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
" gd: go to definition
nmap <silent> gd <Plug>(coc-definition)
" gr: find references
nmap <silent> gr <Plug>(coc-references)
" K: show function/variable documentation (hover)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
" --- NERDTree key mapping ---
" Ctrl+n toggles the left file tree
nnoremap <C-n> :NERDTreeToggle<CR>


set updatetime=300
set shortmess+=c
set signcolumn=yes
" let g:coc_node_path = '/home/lufeifan/.nvm/versions/node/v20.20.2/bin/node'

let g:rainbow_active = 1
