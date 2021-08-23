# `.bash_creds` 読み込み
if [ -f "$HOME/.bash_creds" ]; then
    source $HOME/.bash_creds
fi


[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

PS1='\[\033[00;32m\]\u@\h\[\033[01;34m\] \W\[\033[01;35m\]$(__git_ps1)\[\033[00m\] \$ '
export LSCOLORS=ExgxbxdxCxegedabagacad

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias gr='pt --nogroup -N'
alias ls='ls -G'

[[ -r "/usr/local/opt/asdf/libexec/asdf.sh" ]] && . "/usr/local/opt/asdf/libexec/asdf.sh"

export PATH=$HOME/bin:$PATH
export EDITOR=vim
export HOMEBREW_GITHUB_API_TOKEN=$GITHUB_TOKEN

eval "$(direnv hook bash)"
