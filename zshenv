# ~/.zshenv

# Fixing Hostname and export ENVs
export HOST=$(cat /etc/hosts |grep '^127.0.0.1' |awk '{print $3}')
export EDITOR="/usr/bin/vim"
export HISTFILE="$HOME/.histfile"
export HISTSIZE=500000
export SAVEHIST=500000

# Display last commits in git_diff alias (~/.zprofile)
export LAST_COMMITS=10

# Booking's Proxy
export http_proxy="webproxy.corp.booking.com:3128"

# Perl's Local Lib
export MODULEBUILDRC="/Users/otaviof/perl5/.modulebuildrc"
export PERL_MM_OPT="INSTALL_BASE=/Users/otaviof/perl5"
export PERL5LIB="/Users/otaviof/perl5/lib/perl5:/Users/otaviof/perl5/lib/perl5/darwin-thread-multi-2level"

# Path (Incluing more bin dirs)
export MANPATH="/usr/share/man:/opt/local/share/man:/Users/otaviof/perl5/man"
export PATH="$HOME/perl5/bin:$HOME/.vim/bin/:$HOME/.bin:$PATH"

# VimRC Path
export MYVIMRC="$HOME/.vim/vimrc"

# GitHub API's Token
source $HOME/.github

# EOF
