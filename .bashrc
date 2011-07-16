# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

HISTSIZE=50000
HISTFILESIZE=50000

function gr() {
	WORD=$1;
	shift
	grep $WORD $* -r | grep -v \.svn | grep $WORD --color
}

# default /usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/mix3/bin
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
	source ~/perl5/perlbrew/etc/bashrc
fi

if [ -f ~/dotfiles/.perl.bashrc ]; then
	source ~/dotfiles/.perl.bashrc
fi
