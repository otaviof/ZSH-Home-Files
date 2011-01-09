# ~/.zshrc

# ----------------------------------------------------------------------------
# Functions to display docs inside Vim (MacVim)
# ----------------------------------------------------------------------------

function display_manpage() {
    mvim  \
        -R \
        -c "Man ${*}" \
        -c "silent! only" \
        -c "let no_plugin_maps=1" \
        -c "colors blackboard" \
        -c "set ic nu lines=50 co=110"
}

function display_perldoc() {
    mvim \
        -R \
        -c "silent! only" \
        -c "Perldoc ${*}" \
        -c 'let Perldoc_path="."' \
        -c "setf perldoc" \
        -c "let no_plugin_maps=1" \
        -c "set ic nu lines=50 co=110"
}

function git_prompt_info() {
    sudo git branch --no-color 2> /dev/null \
        |sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function dig_hosts {
    echo $( ack "^[^#].*?$1" /etc/hosts |awk '{print $1}' )
}

# ----------------------------------------------------------------------------
# Compatibility Issues
# ----------------------------------------------------------------------------

setenv() {
    typeset -x "${1}${1:+=}${(@)argv[2,$#]}"
}

freload() {
    while (( $# )); do
        unfunction $1
        autoload -U $1
        shift
    done
}

# ----------------------------------------------------------------------------
# "Hooks" for man commands
# ----------------------------------------------------------------------------

if [[ $OSTYPE == "darwin10.0" ]]; then

    man() {
        [[ $# -eq 0 ]] && return 1
        display_manpage $*
    }

    info() {
        [[ $# -eq 1 ]] || return 1
        display_manpage "${1}.i"
    }

    perldoc() {
        if [[ $# -eq 0 ]]; then
            /usr/bin/perldoc
            return
        fi

        if [[ $1 == '-f' ]]; then
            MAN="$2.pl -f"
        else
            MAN=$1
        fi

        if [[ -f $MAN ]]; then
            echo "Operning a given file name: $MAN"
            /usr/bin/perldoc "$MAN"
            return
        fi

        display_manpage "${MAN}"
    }

fi

# ----------------------------------------------------------------------------
# Completion options
# ----------------------------------------------------------------------------

setopt all_export
setopt append_history
setopt auto_list
setopt autocd
setopt autolist
setopt autopushd
setopt autoresume
setopt cdablevars
setopt extended_glob
setopt extended_history
setopt extendedglob
setopt globdots
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt histignoredups
setopt inc_append_history
setopt longlistjobs
setopt mailwarning
setopt no_beep
setopt nobanghist
setopt noclobber
setopt notify
setopt prompt_subst
setopt pushdminus
setopt pushdsilent
setopt pushdtohome
setopt rcquotes
setopt rcquotes
setopt recexact
setopt rm_star_wait
setopt share_history

unsetopt autoparamslash
unsetopt bg_nice
unsetopt listambiguous

# ----------------------------------------------------------------------------
# ZSH Completion
# ----------------------------------------------------------------------------

zstyle ':completion:*' \
     list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle -e ':completion:*:approximate:*' max-errors \
   'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
zstyle ':completion:*' \
    select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' \
    verbose yes
zstyle ':completion:*:descriptions' \
    format '%B%d%b'
zstyle ':completion:*:messages' \
    format '%d'
zstyle ':completion:*:warnings' \
    format 'No matches for: %d'
zstyle ':completion:*' \
    group-name ''
zstyle ':completion:*' \
    matcher-list 'm:{# a-z}={# A-Z}'
zstyle ':completion:*:*:-subscript-:*' \
    tag-order indexes parameters
zstyle ':completion:*:*:kill:*:processes' \
    command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' \
    list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:(^rm):*:*files' \
    ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'
zstyle ':completion:*' hosts \
    $( sed 's/[\#, ].*$//; /^$/d' /etc/hosts $HOME/.ssh/known_hosts )
zstyle ':completion:*:*:(ssh|scp):*:*' hosts \
    $( sed 's/^\([^ ,]*\).*$/\1/' $HOME/.ssh/known_hosts )
zstyle '*' hosts $hosts

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' \
    ignored-patterns '_*'
zstyle ':completion:*:*:*:users' \
    ignored-patterns '_*'

# completions environment path
fpath=(~/.zsh/completion/ $fpath)

autoload -U ~/.zsh/completion/*(:t)
autoload -Uz compinit
autoload -U colors

compinit -u

# ----------------------------------------------------------------------------
# Command Prompt
# ----------------------------------------------------------------------------

colors && PROMPT=$'%n%{$fg[red]%}@%{$reset_color%}%m:%{$fg[yellow]%}%~%{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}%(#.#.$)%{$reset_color%} '

# ----------------------------------------------------------------------------
# Vim Mode
# ----------------------------------------------------------------------------

bindkey -v

bindkey -M vicmd "j" history-search-forward
bindkey -M vicmd "k" history-search-backward
bindkey -M vicmd "P" insert-last-word

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# ----------------------------------------------------------------------------
# Language
# ----------------------------------------------------------------------------

setenv LANG "en_US.UTF-8"
typeset -U path cdpath fpath manpath

# EOF
