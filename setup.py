#!/usr/bin/env python

"""\
Simple script for helping ZSH's files versioning.
 URL: github.com/otaviof/ZSH-Home-Files
"""

import os
import re
import sys
import time
import shutil
import filecmp
import getopt
import subprocess


def help():
    print """
##
## %(arg0)s -- Very simple manager for ZSH config-files
##

This simple python script aims you to copy and maintain ZSH files in a
different folder, like this GitHub's project shows. Using another place is
handful specially if you're using Git, and want some focus in your ZSH files.

So basically this script reads "MANIFEST" text file (it must be on the same
folder of this script), and in this file we have an placeholder expression to
follow, so please consider own help of MANIFEST file:

    #
    # This file is the _manifest_ of all ZSH's related files on your system
    # that you want to maintain with this simple helper. Here is the place to
    # point them all, but first you must be aware about placeholders:
    #
    # Placeholeders:
    #   <full_path_to_file>:<local_filename>
    #
    # i.e.:
    #   /Users/otaviof/.zshrc:zshrc
    #   /Users/otaviof/.zlogin:zlogin
    #

And all reason for this steps is supporting actions to help you on manintain
your ZSH files:

##
## Actions:
##

  * --push  Copy all ZSH's local files (on the same directory of this script)
            to your home folder following MANIFEST;

  * --pull  Copy your ZSH's files to this directory;

  * --scp   Copy your ZSH's files a remote server, via SCP. And this option
            needs an extra parameter, your SSH host. I.e.:

            %(arg0)s --scp myhost.com              # trust in ~/.ssh/config

All actions test first if files are really different between origin and
destiny, if not it will be just logged as non necessary action.

##
## Usage:
##

    $ %(arg0)s --push
    $ %(arg0)s --pull
    $ %(arg0)s --scp myhost.com
""" % { 'arg0': sys.argv[0] }
    sys.exit()

def manifest():
    """Read and parse local MANIFEST file for keeping track of ZSH's files"""
    separator = re.compile( r'(^#|\S+):(\w+)$' )
    zsh_files = {}
    try:
        f = open('MANIFEST', 'r')
        for line in f:
            m = separator.match(line)
            if m and os.path.isfile(m.group(1)):
                zsh_files[m.group(1)] = m.group(2)
        f.close()
    except OSError, err:
        raise err
    return zsh_files

def copy(o,d):
    """A simple wrapper for copy a file"""
    print "\tCopying: %s, %s" % (o, d)
    try:
        shutil.copyfile(o, d)
    except ( IOError, os.error ), why:
        raise ValueError("Error during copy %s to %s: %s" % (o, d, why))

def boilerplate(left, right):
    """Take list of files described in MANIFEST and make sure we have them in
       both sides, left (external this directory) and right (here!)"""
    if not os.path.isfile(left):
        raise ValueError("File not found: %s" % left)
    if not os.path.isfile(right):
        copy(left, right)

def git_add(file_name, repo_dir=os.curdir):
    cmd  = 'git add ' + file_name
    pipe = subprocess.Popen(cmd, shell=True, cwd=repo_dir)
    pipe.wait()
    return

def git_commit(message, repo_dir=os.curdir):
    cmd = 'git commit -m \'' + message + '\''
    pipe = subprocess.Popen(cmd, shell=True, cwd=repo_dir)
    pipe.wait()
    return

def pull(left, right, suffix=None, other_arguments=None):
    conditional_copy(left, right, None)
    git_add(right)

def push(left, right, suffix, other_arguments=None):
    conditional_copy(right, left, suffix)

def conditional_copy(o,d,backup_suffix):
    """Just copy files that are different than original"""
    is_equal = filecmp.cmp(o, d)
    if not is_equal:
        if backup_suffix:
            copy(d, "/var/tmp/%s.%s" % (os.path.basename(d), backup_suffix))
        copy(o, d)
    else:
        print "\tNot copying: is_equal(%d)" % (is_equal)

def scp(left, right, suffix, other_arguments):
    """Wrap up SCP command"""
    if os.system('scp "%s" "%s:~/.%s"' % (right, other_arguments, right) ) == 0:
        print "Copied to %s via SCP" % other_arguments
    else:
        raise ValueError("Errors during SCP (%s to %s)." % right,
                other_arguments )

def parse_actions():
    """Using getopts to understand command line options and fire up help when
       necessary"""
    try:
        opts, args = getopt.getopt(
            sys.argv[1:],
            'pull:push:scp:help',
            [ 'pull', 'push', 'scp', 'help' ]
        )
    except getopt.GetoptError, err:
        print str(err)
        help()
        sys.exit(2)

    # parsing the first argument, and cleaning it up
    first_argument = None
    if not opts or not opts[0][0]:
        help()
    else:
        first_argument = (str(opts[0][0])).replace('-', '')

    other_arguments = None
    if args and args[0]:
        other_arguments = str(args[0])

    # do we need to show help?
    help_pattern = re.compile(r'help')
    if not opts or help_pattern.match(first_argument):
        help()

    return [ first_argument, other_arguments ]

#
# Main
#

def main():
    # parsing command line options, first of all, and during this process we
    # check is is more appropriated showing help text instead
    first_argument, other_arguments = parse_actions()
    suffix = time.strftime("%Y%m%d%H%M%S")

    # describing all possible options to this script
    actions = {
        "push": push,
        "pull": pull,
        "scp" : scp,
    }

    for left, right in manifest().iteritems():
        print "Left: %s, Right: %s" % (left, right)
        boilerplate(left, right)

        # using dictionary above to call specific actions, or help method
        actions.get(first_argument, help)(
            left,
            right,
            suffix,
            other_arguments
        )

    if first_argument == "pull":
        git_commit(str(time.time()))


if __name__ == '__main__':
    main()

# EOF
