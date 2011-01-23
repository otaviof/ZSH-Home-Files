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

def help():
    print """
%(arg0)s -- Very simple manager for ZSH config files

Actions:
    * "install"  Copy all ZSH's local files (on the same dir of this script)
                 to your home folder;
    * "copy"     Copy your ZSH's files to this directory;

Usage:
    $ %(arg0)s install
    $ %(arg0)s copy
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

def parse_action():
    """Just looking for default arguments, or calling help()"""
    if ( sys.argv.__len__() < 2 or
       ( sys.argv[1] != "install" and
         sys.argv[1] != "copy"
       ) ):
        help()
        sys.exit()
    return sys.argv[1]

def conditional_copy(o,d,backup_suffix):
    """Just copy files that are different than original"""
    is_equal = filecmp.cmp(o, d)
    if not is_equal:
        if backup_suffix:
            copy(d, "%s.%s" % (d, backup_suffix))
        copy(o, d)
    else:
        print "Not copying: is_equal(%d)" % (is_equal)

def copy(o,d):
    """A simple wrapper for copy a file"""
    print "Copying: %s, %s" % (o, d)
    try:
        shutil.copyfile(o, d)
    except ( IOError, os.error ), why:
        raise ValueError("Error during copy %s to %s: %s" % (o, d, why))

def main():
    setup_action = parse_action()
    zsh_files    = manifest()
    suffix       = time.strftime("%Y%m%d%H%M%S")

    for l, r in zsh_files.iteritems():
        print "L: '%s' R: '%s'" % ( l, r )

        # boilerplating the enviroment
        if not os.path.isfile(l):
            raise ValueError("File not found: %s" % (l))
        if not os.path.isfile(r):
            copy(l, r)

        # get the job done!
        if setup_action == "install":
            conditional_copy(r, l, suffix)
        if setup_action == "copy":
            conditional_copy(l, r, None)

if __name__ == '__main__':
    main()

# EOF
