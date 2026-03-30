setlocal noswapfile " 不要生成swap文件
set bufhidden=hide " 当buffer被丢弃的时候隐藏它
set number " 显示行号
" set cursorline " 突出显示当前行
set ruler " 打开状态栏标尺
set shiftwidth=4 " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4 " 使得按退格键时可以一次删掉 4 个空格
set tabstop=4 " 设定 tab 长度为 4
set nobackup " 覆盖文件时不备份
set autochdir " 自动切换当前目录为当前文件所在的目录
set backupcopy=yes " 设置备份时的行为为覆盖
set hlsearch " 搜索时高亮显示被找到的文本
set noerrorbells " 关闭错误信息响铃
set novisualbell " 关闭使用可视响铃代替呼叫
set t_vb= " 置空错误铃声的终端代码
set matchtime=2 " 短暂跳转到匹配括号的时间
set magic " 设置魔术
set smartindent " 开启新行时使用智能自动缩进
set backspace=indent,eol,start " 不设定在插入状态无法用退格键和 Delete 键删除回车符
set cmdheight=1 " 设定命令行的行数为 1
set laststatus=2 " 显示状态栏 (默认值为 1, 无法显示状态栏)
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%) " 设置在状态行显示的信息
set foldenable " 开始折叠
set foldmethod=syntax " 设置语法折叠
set foldcolumn=1 " 设置折叠区域的宽度
setlocal foldlevel=0 " 设置折叠层数为 1
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> " 用空格键来开关折叠

" for in vim visual mode, quick copy to codex-cli
xnoremap <leader>as :<C-u>call system("tmux load-buffer -", @@) \| call system("tmux paste-buffer -t '{left}' -d") \| call system("tmux select-pane -L")<CR>


call plug#begin('~/.vim/plugged')
" Python 语法高亮增强
Plug 'vim-python/python-syntax'

" 通用 LSP/补全（需要 node）
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 自动格式化（可选）
Plug 'psf/black', { 'branch': 'stable' }

" CMake 集成工具 ---
Plug 'cdelledonne/vim-cmake'

" --- 辅助：C/C++ 语法高亮加强 ---
Plug 'bfrg/vim-cpp-modern'

" --- 辅助：文件树（可选，方便看项目结构） ---
Plug 'preservim/nerdtree'

" 
Plug 'luochen1990/rainbow'


" Dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" python-syntax 推荐配置
let g:python_highlight_all = 1
colorscheme dracula

" --- vim-cmake 配置 ---
" 设置按 F4 打开/关闭 CMake 控制台
nnoremap <F4> :CMake<CR>
" 设置按 F5 自动生成构建目录并编译 (相当于 cmake .. && make)
nnoremap <F5> :CMakeGenerate<CR>:CMakeBuild<CR>
" --- coc.nvim 快捷键 ---
" 使用 Tab 键进行代码补全选择
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" 回车键确认补全
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
" gd 跳转到定义 (Go to Definition)
nmap <silent> gd <Plug>(coc-definition)
" gr 查找引用 (Go to References)
nmap <silent> gr <Plug>(coc-references)
" K 显示函数/变量文档 (相当于鼠标悬停)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
" --- NERDTree 文件树快捷键 ---
" 按 Ctrl+n 打开/关闭左侧文件树
nnoremap <C-n> :NERDTreeToggle<CR>


set updatetime=300
set shortmess+=c
set signcolumn=yes
" let g:coc_node_path = '/home/luff/.nvm/versions/node/v20.20.2/bin/node'

let g:rainbow_active = 1
