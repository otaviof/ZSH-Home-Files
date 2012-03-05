# ~/.zprofile
# github.com/otaviof/ZSH-Home-Files

alias ..='cd ..'
alias chmod='chmod -v'
alias chown='chown -v'
alias cp='cp -iv'
alias ff='find ./ -iname $*'
alias mv='mv -iv'
alias rm='rm -iv'
alias perldoc='perldoc -t'
alias tmux='tmux -2'

# ---------------------------------------------------------------------------
# -- Booking's:
#

alias set_http_proxy="eval $(cat ~/.zshenv |grep -i '_proxy')"
alias unset_http_proxy=" \
    eval $(cat ~/.zshenv \
           |grep -i '_proxy' \
           |sed 's/export //g; s/ //g;' \
           |awk -F '=' '{print "unset "$1}')"
alias kill_blackhack="ps aux |ack 'ssh blackhawk' |awk '{print \$2}' |xargs kill"
alias kill_xmldev="ps aux |ack 'ssh xmldev' |awk '{print \$2}' |xargs kill"

# ---------------------------------------------------------------------------
# -- SO Specific:
#


if [[ $_OSTYPE == "darwin" ]]; then

    compctl -f -x 'p[2]' -s "`/bin/ls -d1 /Applications/*/*.app /Applications/*.app |sed 's|^.*/\([^/]*\)\.app.*|\\1|;s/ /\\\\ /g'`" -- open
    alias run='open -a'

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

    alias gitx='open -a GitX --args --local -225 .git'
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

    # some terminal-candy to VirtualBox
    alias tail_ubuntu_vm="tail -F $HOME/VirtualBox\ VMs/void/Logs/VBox.log"

elif [[ $_OSTYPE == "linux" ]]; then

    #
    # GNU/Linux
    #

    # managing paths
    export PATH="${PATH}:${HOME}/.bin"

    alias l.='ls -G -G --color -d .*'
    alias ll='ls -F -G --color -lh '
    alias ls='ls -F -G --color '

    alias mvim="vim"
    alias vi="vim"

    alias hosts="sudo vim /etc/hosts"

    alias tm='tail -f /var/log/messages'
fi

#
# PIP Completion mode
#

# eval "$(pip completion --zsh)"
function _pip_completion {
    local words cword
    read -Ac words
    read -cn cword
    reply=( $( COMP_WORDS="$words[*]" \
               COMP_CWORD=$(( cword-1 )) \
               PIP_AUTO_COMPLETE=1 $words[1] ) )
}

compctl -K _pip_completion pip

# EOF
