# ~/.profile

alias ..='cd ..'
alias chmod='chmod -v'
alias chown='chown -v'
alias cp='cp -iv'
alias ff='find ./ -iname $*'
alias mv='mv -iv'
alias rm='rm -iv'

if [[ $OSTYPE == "darwin10.0" ]]; then

    alias git_diff="[[ -d .git ]] && git log |ack commit |cut -d ' ' -f2 |head -n ${LAST_COMMITS} |xargs -n 2 git diff -R |mvimdiff -R -c 'colorscheme blackboard' -c 'set ic' - > /dev/null 2>&1"
    alias gitx='GitX . > /dev/null 2>&1 &'
    alias gvim='mvim'

    alias l.='ls -FG -d .*'
    alias ll='ls -FG -lh '
    alias ls='ls -FG '

    alias md5sum='md5'

    alias mvim='mvim -c "set columns=110 lines=50"'
    alias mvimdiff='vimdiff'

    alias strace='truss'

    alias vi='vim'
    alias vimdiff='mvim -d'

    # Booking's
    alias kill_blackhack="ps aux |ack 'ssh blackhawk' |awk '{print \$2}' |xargs kill"
    alias kill_xmldev="ps aux |ack 'ssh xmldev' |awk '{print \$2}' |xargs kill"

elif [[ $OSTYPE == "linux-gnu" ]]; then

    alias l.='ls -G -G --color -d .*'
    alias ll='ls -F -G --color -lh '
    alias ls='ls -F -G --color '
    alias tm='tail -f /var/log/messages'

fi

# EOF
