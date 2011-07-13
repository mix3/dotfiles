" Vundle
source ~/.vimrc.vundle

" {{{ 場所ごとの設定
augroup vimrc-local
	autocmd!
	autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END
function! s:vimrc_local(loc)
	let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
	for i in reverse(filter(files, 'filereadable(v:val)'))
		source `=i`
	endfor
endfunction
" }}}

" 色設定
syntax on

" タブの設定 タブのまま 幅4
set softtabstop=0
set shiftwidth=4
set tabstop=4
set autoindent

" タブ文字可視化
set list
set listchars=tab:>\ 

" swapファイル作らない
set noswapfile

" backupしない
set nobackup

" 他で編集されたら読み込み直す
set autoread

" カーソルキーで行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>

" 文字コードの自動認識
source ~/.vimrc.encode
