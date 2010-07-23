# ~/.zshrc

#
# Functions to display docs inside Vim (MacVim)
#

function display_manpage() {
    mvim                                        \
        -R                                      \
        -c "Man ${*}"                           \
        -c "silent! only"                       \
        -c "set ic invnumber"                   \
        -c "colors blackboard"                  \
        -c "set guifont=Menlo\ Regular:h13"     \
        -c "set columns=110 lines=50"
}

function display_perldoc() {
    mvim                                        \
        -R                                      \
        -c "set guifont=Menlo\ Regular:h13"     \
        -c "silent! only"                       \
        -c 'let Perldoc_path="."'               \
        -c "Perldoc ${*}"                       \
        -c "setf perldoc"                       \
        -c "set ic number columns=110 lines=50"
}

#
# Overiding methods
#

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

#
# KeyChain
#

source $HOME/.zlogin

# EOF
