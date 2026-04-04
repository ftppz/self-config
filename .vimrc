setlocal noswapfile " Do not create swap files
set bufhidden=hide " Hide buffer when it is abandoned
set number " Show line numbers
set cursorline " Highlight the current line
set ruler " Show the ruler in status area
set shiftwidth=4 " Set << and >> indent width to 4
set softtabstop=4 " Make backspace delete 4 spaces at a time
set tabstop=4 " Set tab width to 4
set nobackup " Do not create backup when overwriting files
set autochdir " Automatically change cwd to current file's directory
set backupcopy=yes " Use overwrite behavior for backups
set hlsearch " Highlight matched search text
set noerrorbells " Disable error bells
set novisualbell " Disable visual bell fallback
set t_vb= " Clear terminal code for error bell
set matchtime=2 " Brief jump time to matching bracket
set magic " Enable magic for patterns
set smartindent " Enable smart auto-indent on new lines
set backspace=indent,eol,start " Allow backspace/delete over indent, EOL, and insert start
set cmdheight=1 " Set command-line height to 1
set laststatus=2 " Always show status line (default is 1)
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%) " Status line content
set foldenable " Enable folding
set foldmethod=syntax " Use syntax-based folding
set foldcolumn=1 " Set fold column width
setlocal foldlevel=0 " Set initial fold level to 0
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> " Toggle fold with Space

xnoremap <leader>as y:<C-u>call system('tmux load-buffer -', @")<Bar>call system("tmux paste-buffer -t '{left}' -d")<Bar>call system('tmux select-pane -L')<CR>

" In normal mode, Ctrl+j moves line down, Ctrl+k moves line up
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" In visual mode, Ctrl+j/k moves the selected block up/down
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv


call plug#begin('~/.vim/plugged')
" Enhanced Python syntax highlighting
Plug 'vim-python/python-syntax'

" General LSP/completion (requires Node.js)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Auto formatting (optional)
Plug 'psf/black', { 'branch': 'stable' }

" CMake integration tool ---
Plug 'cdelledonne/vim-cmake'

" --- Helper: improved C/C++ syntax highlighting ---
Plug 'bfrg/vim-cpp-modern'

" --- Helper: file tree (optional, useful for project structure) ---
Plug 'preservim/nerdtree'

" 
Plug 'luochen1990/rainbow'


" Dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" Recommended python-syntax setting
let g:python_highlight_all = 1
colorscheme dracula

" --- vim-cmake config ---
" Press F4 to open/close CMake console
nnoremap <F4> :CMake<CR>
" Press F5 to generate build directory and build (like cmake .. && make)
nnoremap <F5> :CMakeGenerate<CR>:CMakeBuild<CR>
" --- coc.nvim key mappings ---
" Use Tab to navigate completion items
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Enter to confirm completion
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
" gd: go to definition
nmap <silent> gd <Plug>(coc-definition)
" gr: find references
nmap <silent> gr <Plug>(coc-references)
" K: show function/variable docs (like hover)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
" --- NERDTree key mapping ---
" Press Ctrl+n to toggle the left file tree
nnoremap <C-n> :NERDTreeToggle<CR>


set updatetime=300
set shortmess+=c
set signcolumn=yes

let g:rainbow_active = 1
