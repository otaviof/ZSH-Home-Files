# ~/.profile
# github.com/otaviof/ZSH-Home-Files

alias ..='cd ..'
alias chmod='chmod -v'
alias chown='chown -v'
alias cp='cp -iv'
alias ff='find ./ -iname $*'
alias mv='mv -iv'
alias rm='rm -iv'

# ---------------------------------------------------------------------------
# Booking's
#

alias set_http_proxy="eval $(cat ~/.zshenv |grep -i '_proxy')"
alias unset_http_proxy=" \
    eval $(cat ~/.zshenv \
           |grep -i '_proxy' \
           |sed 's/^export //g; s/ //g;' \
           |awk -F '=' '{print "unset "$1}')"
alias kill_blackhack="ps aux |ack 'ssh blackhawk' |awk '{print \$2}' |xargs kill"
alias kill_xmldev="ps aux |ack 'ssh xmldev' |awk '{print \$2}' |xargs kill"

# ---------------------------------------------------------------------------
# SO Specific
#


if [[ $OSTYPE == "darwin10.0" || $OSTYPE == "darwin10.6.0" ]]; then

    #
    # Mac OS X
    #

    alias git_diff=" \
        [[ -d .git ]] && git log \
        |ack commit \
        |cut -d ' ' -f2 \
        |head -n ${LAST_COMMITS} \
        |xargs -n 2 git diff -R \
        |mvimdiff -R -c 'colorscheme blackboard' -c 'set ic' - > /dev/null 2>&1"

    alias gitx='/usr/local/bin/gitx --local -250'
    alias gvim='mvim'

    alias hosts="sudo mvim /etc/hosts"

    alias l.='ls -FG -d .*'
    alias ll='ls -FG -lh '
    alias ls='ls -FG '

    alias less='vimpager'

    alias md5sum='md5'

    alias mvim='EDITOR="" mvim -c "set columns=110 lines=50"'
    alias mvimdiff='vimdiff'

    alias strace='truss'

    alias vi='vim'
    alias vimdiff='mvim -d'

elif [[ $OSTYPE == "linux-gnu" ]]; then

    #
    # GNU/Linux
    #

    alias l.='ls -G -G --color -d .*'
    alias ll='ls -F -G --color -lh '
    alias ls='ls -F -G --color '

    alias mvim="vim"
    alias vi="vim"

    alias hosts="sudo vim /etc/hosts"

    alias tm='tail -f /var/log/messages'
fi

# EOF
