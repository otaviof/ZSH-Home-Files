# ~/.profile

alias ..='cd ..'
alias chmod='chmod -v'
alias chown='chown -v'
alias cp='cp -iv'
alias ff='find ./ -iname $*'
alias l.='ls -dG .*'
alias ls='ls -FG '
alias md5sum='md5'
alias mv='mv -iv'
alias rm='rm -iv'
alias tm='tail -f /var/log/messages'

# Devel and Editors
alias gitx='GitX . > /dev/null 2>&1 &'
alias gvim='mvim'
alias mvim='mvim -c "set columns=110 lines=50"'
alias mvimdiff='vimdiff'
alias vi='vim'
alias vimdiff='mvim -d'
alias git_diff="[[ -d .git ]] && git log |ack commit |cut -d ' ' -f2 |head -n ${LAST_COMMITS} |xargs -n 2 git diff -R |mvimdiff -R -c 'colorscheme blackboard' -c 'set ic' - > /dev/nul 2>&1"

# Booking's
alias kill_blackhack="ps aux |ack 'ssh blackhawk' |awk '{print \$2}' |xargs kill"
alias kill_xmldev="ps aux |ack 'ssh xmldev' |awk '{print \$2}' |xargs kill"

# EOF
