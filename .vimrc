if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'thinca/vim-localrc'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'

" nerdtree {{{
  nnoremap <C-n> :NERDTreeToggle<CR>
" }}}

" neocomplcache {{{
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 1
  " Use camel case completion.
  let g:neocomplcache_enable_camel_case_completion = 1
  " Use underbar completion.
  let g:neocomplcache_enable_underbar_completion = 1
  " Disable auto completion
  let g:neocomplcache_disable_auto_complete = 1
  " <BS>: close popup and delete backword char.
  "inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
" }}}

" neosnippet {{{
  " Plugin key-mappings.
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)

  " SuperTab like snippets behavior.
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"

  " For snippet_complete marker.
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif
" }}}

filetype plugin indent on

NeoBundleCheck

filetype off
filetype plugin indent off

" :Fmt などで gofmt の代わりに goimports を使う
let g:gofmt_command = 'goimports'

" Go に付属の plugin と gocode を有効にする
set rtp^=${GOROOT}/misc/vim
set rtp^=${GOPATH}/src/github.com/nsf/gocode/vim

" 保存時に :Fmt する
au BufWritePre *.go Fmt
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4
au FileType go compiler go

" vi互換off
set nocompatible

" 色設定
syntax on
colorscheme peachpuff

" タブの設定 タブのまま 幅4
set softtabstop=0
set shiftwidth=4
set tabstop=4
set autoindent

" タブ文字可視化
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

" 全角スペース・行末のスペース・タブの可視化
if has("syntax")
  syntax on

  " PODバグ対策
  syn sync fromstart

  function! ActivateInvisibleIndicator()
    " 下の行の"　"は全角スペース
    syntax match InvisibleJISX0208Space "　" display containedin=ALL
    highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=darkgray gui=underline
    "syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
    "highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=NONE gui=undercurl guisp=darkorange
    "syntax match InvisibleTab "\t" display containedin=ALL
    "highlight InvisibleTab term=underline ctermbg=white gui=undercurl guisp=darkslategray
  endfunction

  augroup invisible
    autocmd! invisible
    autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
  augroup END
endif

" swapファイル作らない
set noswapfile

" backupしない
set nobackup

" 他で編集されたら読み込み直す
set autoread

" カーソルキーで行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>

" 検索文字列のハイライト
set hlsearch

" インサートモード時にバックスペースを使う
set backspace=indent,eol,start

" .t .psgi もperl syntax で
autocmd BufNewFile,BufRead *.psgi set filetype=perl
autocmd BufNewFile,BufRead *.t    set filetype=perl
autocmd BufNewFile,BufRead *.tx   set filetype=html

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

"タブ切り替え
nnoremap <C-l> gt
nnoremap <C-h> gT

" 開いてるファイルにのディレクトリに移動
command! -nargs=0 CD :execute 'lcd ' . expand("%:p:h")

" エンコード自動判別
set encoding=utf-8
source $HOME/.vim/encode.vim
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

filetype plugin indent on
filetype on
