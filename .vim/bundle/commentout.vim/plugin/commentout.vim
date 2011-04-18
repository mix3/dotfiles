"-----------------------------------------------------------------------------
" Comment-out

let g:commentout_schemes = {
      \ '#': {
      \   1: { 'type': 'lhs',   'leader': '#'  },
      \ },
      \ 'c': {
      \   1: { 'type': 'wrap',  'leader': '/*',   'trailer': '*/' },
      \   3: { 'type': 'block', 'leader': '/*',   'trailer': '*/' },
      \ },
      \ 'cpp': {
      \   1: { 'type': 'lhs',   'leader': '//' },
      \   2: { 'type': 'wrap',  'leader': '/*',   'trailer': '*/' },
      \   3: { 'type': 'block', 'leader': '/*',   'trailer': '*/' },
      \ },
      \ 'html': {
      \   1: { 'type': 'wrap',  'leader': '<!--', 'trailer': '-->' },
      \   3: { 'type': 'block', 'leader': '<!--', 'trailer': '-->' },
      \ },
      \ 'vim': {
      \   1: { 'type': 'lhs',   'leader': '"'  },
      \ },
      \ }

let g:commentout_line_leaders  = []
let g:commentout_line_trailers = []
for scheme_group in values(g:commentout_schemes)
  for scheme in values(scheme_group)
    if scheme.type !=# 'block'
      if index(g:commentout_line_leaders,  scheme.leader) < 0
        call add(g:commentout_line_leaders,  scheme.leader)
      endif
      if has_key(scheme, 'trailer')
        if index(g:commentout_line_trailers, scheme.trailer) < 0
          call add(g:commentout_line_trailers, scheme.trailer)
        endif
      endif
    endif
  endfor
endfor

function! s:commentout_scheme_alias(orig, ...)
  for lang in a:000
    let g:commentout_schemes[lang] = g:commentout_schemes[a:orig]
  endfor
endfunction

call s:commentout_scheme_alias('#', 'ruby', 'perl', 'python', 'sh', 'zsh')
call s:commentout_scheme_alias('c', 'css')
call s:commentout_scheme_alias('cpp', 'java', 'javascript')
call s:commentout_scheme_alias('html', 'xhtml')

"---------------------------------------
" Encomment

function! s:encomment_dwim(type, ...) range
  if !has_key(g:commentout_schemes, &l:filetype)
    echoerr "Comment-out scheme not registered for: " . &l:filetype
    return
  endif
  if !has_key(g:commentout_schemes[&l:filetype], a:type)
    echoerr "Comment-out scheme for `" . &l:filetype . "' not support type " . a:type
    return
  endif
  let scheme = g:commentout_schemes[&l:filetype][a:type]
  let range = a:firstline . ',' . a:lastline

  if scheme.type ==# 'lhs'
    execute ':'.range.'call s:encomment_line(scheme.leader, "", a:0)'
  elseif scheme.type ==# 'wrap'
    execute ':'.range.'call s:encomment_line(scheme.leader, scheme.trailer, a:0)'
  elseif scheme.type ==# 'block'
    execute ':'.range.'call s:encomment_block(scheme.leader, scheme.trailer, a:0)'
  endif
endfunction

function! s:encomment_line(lead, trail, with_copy) range
  let range = a:firstline . ',' . a:lastline
  let lead  = escape(a:lead, '/')
  let trail = escape(a:trail, '/')
  let lead_ws = '^ \{,' . strlen(a:lead) . '\}'

  if a:with_copy
    execute ':'.range.'yank v'
  endif
  if a:trail == ""
    " lhs comments
    silent execute ':'.range.'s/'.lead_ws.'/'.lead.'/'
  else
    " wrapping comments
    silent execute ':'.range.'s/'.lead_ws.'\(\s*\)\(.*\)$/'.lead.' \1\2 '.trail.'/'

    if exists(":Align") == 2
      execute ':'.range.'Align! p1P0 '.trail
      call s:post_align()
    endif
  endif
  if a:with_copy
    execute "normal! '>\"vp"
  endif
endfunction

function! s:encomment_block(lead, trail, with_copy) range
  let range =  a:firstline . ',' . a:lastline
  if a:with_copy
    execute ':'.range.'yank v'
  endif
  execute "normal! \<Esc>\<Esc>`<I\<CR>\<Esc>k0i" . a:lead . "\<Esc>" .
        \ '`>j0i' . a:trail . "\<CR>\<Esc>\<Esc>"
  if a:with_copy
    execute 'normal! "vP'
  endif
endfunction

" lhs comments
xnoremap <silent> ," :call <SID>encomment_line('"',  '', 0)<CR>
xnoremap <silent> ,; :call <SID>encomment_line(';',  '', 0)<CR>
xnoremap <silent> ,> :call <SID>encomment_line('> ', '', 0)<CR>

xnoremap <silent> ,," :call <SID>encomment_line('"',  '', 1)<CR>
xnoremap <silent> ,,; :call <SID>encomment_line(';',  '', 1)<CR>
xnoremap <silent> ,,> :call <SID>encomment_line('> ', '', 1)<CR>

" wrapping comments
xnoremap <silent> ,* :call <SID>encomment_line('/*', '*/', 0)<CR>
xnoremap <silent> ,< :call <SID>encomment_line('<!--', '-->', 0)<CR>

xnoremap <silent> ,,* :call <SID>encomment_line('/*', '*/', 1)<CR>
xnoremap <silent> ,,< :call <SID>encomment_line('<!--', '-->', 1)<CR>

" block comments
xnoremap <silent> <Leader>* :call <SID>encomment_block('/*',  '*/', 0)<CR>
xnoremap <silent> <Leader>< :call <SID>encomment_block('<!--', '-->', 0)<CR>

xnoremap <silent> <Leader><Leader>* :call <SID>encomment_block('/*', '*/', 1)<CR>
xnoremap <silent> <Leader><Leader>< :call <SID>encomment_block('<!--', '-->', 1)<CR>

" dwim
for nr in range(1,9)
 execute 'xnoremap <silent> ,' .nr ':call <SID>encomment_dwim('.nr.')<CR>'
 execute 'xnoremap <silent> ,,'.nr ':call <SID>encomment_dwim('.nr.', 1)<CR>'
endfor

xmap ,# ,1
xmap ,,# ,,1

xmap # ,#

"---------------------------------------
" Decomment 

function! s:decomment_dwim() range
  if !has_key(g:commentout_schemes, &l:filetype)
    echoerr "Comment-out scheme not registered for: " . &l:filetype
    return
  endif
  let range = a:firstline . ',' . a:lastline
  let block_leads  = []
  let block_trails = []
  let  line_leads  = []
  let  line_trails = []
  for scheme in values(g:commentout_schemes[&l:filetype])
    if scheme.type ==# 'block'
      call add(block_leads,  scheme.leader)
      call add(block_trails, scheme.trailer)
    else
      call add(line_leads, scheme.leader)
      if has_key(scheme, 'trailer')
        call add(line_trails, scheme.trailer)
      endif
    endif
  endfor
  let fst_line = getline(a:firstline)
  let lst_line = getline(a:lastline)
  let pat_block_leads  = '\(' . join(map(block_leads,  "util#escape_vregex(v:val)"), '\|') . '\)'
  let pat_block_trails = '\(' . join(map(block_trails, "util#escape_vregex(v:val)"), '\|') . '\)'
  if match(fst_line, pat_block_leads) && !match(fst_line, pat_block_trails) &&
        \ match(lst_line, pat_block_trails)
    " block comment
    execute ':'.range.'call s:decomment_block()'
  else
    " line comment
    execute ':'.range.'call s:decomment_line(line_leads, line_trails)'
  endif
endfunction

function! s:decomment_line(leads, trails) range
  let range = a:firstline . ',' . a:lastline
  if empty(a:leads)
    let leads = g:commentout_line_leaders
  else
    let leads = a:leads
  endif
  if empty(a:trails)
    let trails = g:commentout_line_trailers
  else
    let trails = a:trails
  endif
  let pat_leads  = '\(' . join(map(leads,  "util#escape_vregex(v:val, '/')"), '\|') . '\)'
  let pat_trails = '\(' . join(map(trails, "util#escape_vregex(v:val, '/')"), '\|') . '\)'

  silent! execute ':'.range.'s/^\s*'.pat_leads .'//'
  silent! execute ':'.range.'s/\s*' .pat_trails.'\s*$//'
  normal! `<=`>
endfunction

function! s:decomment_block() range
  execute "normal! \<Esc>\<Esc>'<\"_dd'>\"_dd"
endfunction

xnoremap <silent> ,/ :call <SID>decomment_line([], [])<CR>
xnoremap <silent> <Leader>/ :call <SID>decomment_block()<CR>

" dwim
xnoremap <silent> ,0 :call <SID>decomment_dwim()<CR>
xmap / ,0
