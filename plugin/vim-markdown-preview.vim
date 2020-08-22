"============================================================
"                    Vim Markdown Preview
"   git@github.com:JamshedVesuna/vim-markdown-preview.git
"============================================================
let s:vim_markdown_preview_state = -1

function! g:AsyncMDCallback(title, curr_wid)
    let chrome_wid = system("xdotool search --name " . a:title)
    if !chrome_wid
        call system("see vim-markdown-preview.html 1>/dev/null 2>/dev/null && xdotool windowactivate " . a:curr_wid)
    else
        call system("xdotool search --name " . a:title . " windowactivate --sync %1 key F5 windowactivate " . a:curr_wid)
    endif

    silent exec "!(sleep 1 && rm vim-markdown-preview.html) &"

endfunction

function! Vim_Markdown_Preview_Local()
    if s:vim_markdown_preview_state == -1
        return
    endif

    let b:curr_file = expand('%:p')
    let b:title = expand('%:p:h') . ": " . expand("%")

    let curr_wid = system('xdotool getwindowfocus')
    let cmd =  "grip " . shellescape(b:curr_file) . " --export vim-markdown-preview.html --title " . shellescape(b:title)

    call asyncrun#run("",
                \ {"post": "call g:AsyncMDCallback(" . shellescape(b:title ." - " . g:vim_markdown_preview_browser) . ", '" . curr_wid . "')"},
                \ cmd)
 
endfunction

"Display images - Automatically call Vim_Markdown_Preview_Local() on buffer write
autocmd! BufWritePost *.markdown,*.md :call Vim_Markdown_Preview_Local()
command! MDPrevToggle let s:vim_markdown_preview_state *= -1
