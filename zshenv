# ~/.zshenv

# Fixing Hostname and setenv  ENVs
export EDITOR="mvim -f"
export HISTFILE="$HOME/.histfile"
export HISTSIZE=500000
export HOST=$(cat /etc/hosts |grep '^127.0.0.1' |awk '{print $3}')
export SAVEHIST=500000
export TERM="xterm"

# Display last commits in git_diff alias (~/.zprofile)
export LAST_COMMITS=10

# Booking's Proxy
export http_proxy="webproxy.corp.booking.com:3128"

# Path (Incluing more bin dirs)
export  MANPATH="/usr/share/man:/opt/local/share/man:$HOME/perl5/man"
export  PATH="$HOME/perl5/bin:$HOME/.vim/bin/:$HOME/.bin:$PATH"

# VimRC Path
export  MYVIMRC="$HOME/.vim/vimrc"

# GitHub API's Token
source $HOME/.github

#
# Perl's Local Lib
#

export MODULEBUILDRC="$HOME/perl5/.modulebuildrc"
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

if [[ $OSTYPE == "darwin10.0" ]]; then
    PERL5LIB="$HOME/perl5/lib/perl5:$HOME/perl5/lib/perl5/darwin-thread-multi-2level"
else
    PERL5LIB="$HOME/perl5/lib/perl5:$HOME/perl5/lib/perl5/x86_64-linux-gnu-thread-multi"
fi

export PERL5LIB=$PERL5LIB

# EOF
