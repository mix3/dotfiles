"------------------------
" pathogen
"------------------------
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"------------------------
" neocomplcache
"------------------------
let g:neocomplcache_enable_at_startup = 1

"------------------------
" settings
"------------------------
"色設定
syntax on

"タブの設定
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
set autoindent

"検索
set incsearch
set ignorecase
set smartcase
set nohlsearch

"コマンドラインの高さ
set cmdheight=1

"バックスペースで何でも消したい
set backspace=indent,eol,start

"タブバー常に表示
set showtabline=2

"タブ文字可視化
set list
set listchars=tab:>\ 

"他で編集されたら読み込み直す
set autoread

"ステータスラインの表示設定
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'}%=%l,%c%V%8P

"カーソルキーで行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>

" ファイルタイプごとに辞書ファイルを指定
autocmd FileType vim :set dictionary+=~/.vim/dict/vim_functions.dict
autocmd FileType php :set dictionary+=~/.vim/dict/php_functions.dict

"辞書ファイルを使用する設定に変更
set complete+=k

"-----------------------
" tab
"------------------------

" タブラインの設定
" from :help setting-tabline
set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
" 強調表示グループの選択
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

" タブページ番号の設定 (マウスクリック用)
    let s .= '%' . (i + 1) . 'T'

" ラベルは MyTabLabel() で作成する
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

" 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセッ
" トする
  let s .= '%#TabLineFill#%T'

" カレントタブページを閉じるボタンのラベルを右添えで作成
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return expand("#".buflist[winnr - 1].":t")
endfunction

" 開いてるファイルにのディレクトリに移動
command! -nargs=0 CD :execute 'lcd ' . expand("%:p:h")

"------------------------
" keymaps
"------------------------
"タブ文字（\t）を入力
inoremap <C-Tab> <C-v><Tab>

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>

"エスケープキー
inoremap <C-j> <esc>
vnoremap <C-j> <esc>

"タブ切り替え
nnoremap <C-l> gt
nnoremap <C-h> gT

"------------------------
" nano settings
"------------------------
function Nano ()
  inoremap <C-i> <C-o>
  inoremap <C-o> <C-o>:w<Enter>
  inoremap <C-x> <C-o>:q<Enter>
  inoremap <C-v> <C-o><C-F>
  inoremap <C-y> <C-o><C-b>
  inoremap <Down> <C-o>g<Down>
  inoremap <Up> <C-o>g<Up>
  " <Nul> = ctrl-space
  inoremap <Nul> <C-o>W
endfunction
