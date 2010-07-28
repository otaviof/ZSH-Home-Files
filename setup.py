#!/usr/bin/env python

"""
Very simple script for help in ZSH's files versioning.
"""

import os
import difflib
import glob
import shutil
import sys

def main():
    """Copying new, newer or unexistent files"""
    zfiles = glob.glob('%s/.z*' % os.getenv('HOME'))
    for z in zfiles:
        if not os.path.isfile(z):
            continue
        name = os.path.basename(z).lstrip('.')
        if  not os.path.isfile(name) or (difflib.SequenceMatcher(None, open(z).read(), open(name).read()) and (os.path.getmtime(z) > os.path.getmtime(name))):
            try:
                print "Copying: %s, %s" % (z, name)
                shutil.copyfile(z, name)
            except OSError, err:
                print err
                sys.exit(2)

if __name__ == '__main__':
    main()
