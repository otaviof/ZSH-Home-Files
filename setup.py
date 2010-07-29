#!/usr/bin/env python

"""Simple script for helping ZSH's files versioning."""

import os
import difflib
import glob
import shutil
import sys

def main():
    """Copying new, newer or inexistent local files"""
    zfiles = glob.glob('%s/.z*' % os.getenv('HOME'))
    for z in zfiles:
        if not os.path.isfile(z):
            continue
        name = os.path.basename(z).lstrip('.')
        is_different = difflib.SequenceMatcher(
                None, open(z).read(), open(name).read())
        is_newer = os.path.getmtime(z) > os.path.getmtime(name)
        if not os.path.isfile(name) or (is_different and is_newer):
            try:
                print "Copying: %s, %s" % (z, name)
                shutil.copyfile(z, name)
            except OSError, err:
                print err and sys.exit(2)

if __name__ == '__main__':
    main()

# EOF
