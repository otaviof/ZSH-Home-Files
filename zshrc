# ~/.zshrc
# github.com/otaviof/ZSH-Home-Files

fpath=(
    /usr/local/share/zsh-completions
    ${HOME}/.zsh/completion/
    ${fpath}
)

autoload -U ~/.zsh/completion/*(:t)
autoload -Uz compinit && compinit -u
autoload -U colors && colors

# ----------------------------------------------------------------------------
# -- Command Prompt:
# ----------------------------------------------------------------------------

autoload -Uz edit-command-line

if [[ "$MODE_INDICATOR" == "" ]]; then
    MODE_INDICATOR="%{$fg_bold[red]%}<%{$reset_color%}%{$fg[red]%}<<%{$reset_color%}"
fi

function zle-line-init {
    zle reset-prompt
}

rprompt_cached=$RPROMPT
function zle-line-init zle-keymap-select {
    RPROMPT="${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/$rprompt_cached}"
    zle reset-prompt
}

# Accept RETURN in vi command mode.
function accept_line {
    RPROMPT=$rprompt_cached
    builtin zle .accept-line
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N accept_line
zle -N edit-command-line

PROMPT=$'%{$reset_color%}%n%{$fg[red]%}@%{$reset_color%}%m:%{$fg[yellow]%}%~%{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}%(#.#.$) %'

setopt prompt_subst

# ----------------------------------------------------------------------------
# -- Vim Mode:
# ----------------------------------------------------------------------------

# Avoid binding ^J, ^M,  ^C, ^?, ^S, ^Q, etc.
bindkey -d # Reset to default.
bindkey -v # Use vi key bindings.
bindkey -M vicmd "^M" accept_line # Alow RETURN in vi command.
bindkey -M vicmd v edit-command-line # ESC-v to edit in an external editor.

bindkey ' ' magic-space 
bindkey -M vicmd "gg" beginning-of-history
bindkey -M vicmd "G" end-of-history
bindkey -M vicmd "k" history-search-backward
bindkey -M vicmd "j" history-search-forward
# bindkey -M vicmd "?" history-incremental-search-backward
# bindkey -M vicmd "/" history-incremental-search-forward

bindkey -M viins "^L" clear-screen
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# ----------------------------------------------------------------------------
# -- Misc Methods:
# ----------------------------------------------------------------------------

function git_prompt_info() {
    git branch --no-color 2> /dev/null \
        |sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function dig_hosts {
    echo $( ack "^[^#].*?$1" /etc/hosts |awk '{print $1}' )
}

# ----------------------------------------------------------------------------
# -- Compatibility Issues:
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
# -- Completion options:
# ----------------------------------------------------------------------------

setopt all_export
setopt append_history
setopt auto_list
setopt autocd
setopt autolist
setopt autopushd
setopt autoresume
setopt no_cdablevars
setopt extended_glob
setopt extended_history
setopt extendedglob
setopt globdots
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
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
setopt pushdminus
setopt pushdsilent
setopt pushdtohome
setopt rcquotes
setopt rcquotes
setopt recexact
setopt rm_star_wait
setopt share_history
# setopt chase_links
setopt interactive_comments

unsetopt autoparamslash
unsetopt bg_nice
unsetopt listambiguous

# ----------------------------------------------------------------------------
# -- ZSH Completion:
# ----------------------------------------------------------------------------

zstyle ':completion:*' \
    use-cache on
zstyle ':completion:*' \
    cache-path ~/.zsh/cache
zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
    'local-directories named-directories'
zstyle ':completion:*' \
     list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' \
    group-name ''
zstyle ':completion:*:descriptions' \
    format '%S%d%s'
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

# ----------------------------------------------------------------------------
# -- Language:
# ----------------------------------------------------------------------------

setenv LANG "en_US.UTF-8"

# ----------------------------------------------------------------------------
# -- Window title:
# ----------------------------------------------------------------------------

case $TERM in
    *xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
        precmd ()  { print -Pn "\e]0;%M: %~\a" }
        preexec () { print -Pn "\e]0;%M: %~ $1\a" }
    ;;
    screen)
        precmd () {
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;$TERM - (%L) %M: %~\a"
        }
        preexec () {
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;$TERM - (%L) %M: %~ $1\a"
        }
    ;;
esac

# EOF
