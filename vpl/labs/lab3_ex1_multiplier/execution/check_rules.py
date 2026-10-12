#!/usr/bin/env python3
# Rule check: the operator * (multiplication) is not allowed in this exercise.
import re, sys
sys.stdout.reconfigure(encoding="utf-8")

def strip(src):
    src = re.sub(r"/\*.*?\*/", " ", src, flags=re.S)       # block comments
    src = re.sub(r"//[^\n]*", " ", src)                     # line comments
    src = re.sub(r"@\s*\(\s*\*\s*\)", " ", src)               # always @(*)
    src = re.sub(r"@\s*\*", " ", src)                       # always @*
    return src

bad = [f for f in sys.argv[1:] if "*" in strip(open(f, encoding="utf-8", errors="replace").read())]
if bad:
    print("Operatorul * (înmulțire) nu are voie să fie folosit în acest exercițiu: " + ", ".join(bad))
    sys.exit(1)
