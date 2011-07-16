# by http://tech.bayashi.jp/archives/entry/perl/2011/003303.html

export PERLDOC_PAGER=lv

function pm() {
	[ -n "$1" ] && perldoc -m $1
}

function pv() {
	[ -n "$1" ] && perl -e "use $1;print qq|$1: \$$1::VERSION\n|;";
}

function pmgrep() {
	[ -n "$1" ] && [ -n "$2" ] && grep -C3 -n "$1" `perldoc -l $2` | less -r;
}
