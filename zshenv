# ~/.zshenv
# github.com/otaviof/ZSH-Home-Files

# defining a simpler OSTYPE
if [[ -n "$OSTYPE" ]]; then
    if ( expr "$OSTYPE" : 'darwin' > /dev/null ); then
        export _OSTYPE="darwin"
    elif ( expr "$OSTYPE" : 'linux' > /dev/null ); then
        export _OSTYPE="linux"
    fi
fi

# Fixing Hostname and setenv  ENVs
export     HOST=$(head -n 5 /etc/hosts |grep '^127' |awk '{print $3}')
export     TERM="rxvt"
export   EDITOR="mvim -f"
export HISTFILE="$HOME/.histfile"
export HISTSIZE=500000
export SAVEHIST=500000

# TODO: a better way do test if it's my mac or not
if [[ -z "$SSH_CONNECTION" && $_OSTYPE == "darwin" ]]; then
    export PAGER="vimpager"
    # avoid build for other archs
    export ARCHFLAGS="-arch x86_64" # -arch i386 -arch x86_64 -arch ppc
    # network location
    export OSX_NETWORK_LOCATION=$(scselect 2>&1 |egrep '^ \* ' |sed 's/.*(\(.*\))/\1/;')
fi

# Display last commits in git_diff alias (~/.zprofile)
export LAST_COMMITS=10

# MacVim's mvim helper
export VIM_APP_DIR="/Applications"

# Booking's Proxy
if [[ "$OSX_NETWORK_LOCATION" != "Home" ]]; then
    export BOOKINGS_PROXY="http://webproxy.corp.booking.com:3128"
    export      ftp_proxy=$BOOKINGS_PROXY
    export     http_proxy=$BOOKINGS_PROXY
    export    https_proxy=$BOOKINGS_PROXY
fi

# VimRC Path
export  MYVIMRC="$HOME/.vim/vimrc"

# GitHub API's Token
source $HOME/.github

#
# System-wide environment settings for ZSH
#
# FIXME:
#   - in first place this path_helper should be called from /etc/zshenv, but
#     for some awkward reason it's not being true;
#

[[ -x '/usr/libexec/path_helper' ]] && \
    eval "$(/usr/libexec/path_helper -s)"

#
# Perl's Local Lib
#

export   PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
export MODULEBUILDRC="$HOME/perl5/.modulebuildrc"

if [[ $_OSTYPE == "darwin" ]]; then
    PERL5LIB="$HOME/D/P/B/main/lib:$HOME/perl5/lib/perl5:$HOME/perl5/lib/perl5/darwin-thread-multi-2level"
else
    PERL5LIB="$HOME/perl5/lib/perl5:$HOME/perl5/lib/perl5/x86_64-linux-gnu-thread-multi"
fi

export PERL5LIB=$PERL5LIB

# EOF
