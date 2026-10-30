#!/usr/bin/env python3
"""Source scan of the candidate: proof holes, axioms, module headers, file sizes, import closure.
Run from the project root:  python3 -I verification/content-checks.py"""
import os, re, sys
root = '.'
lean = []
for d, dirs, files in os.walk(root):
    dirs[:] = [x for x in dirs if x not in ('.lake', '.git')]
    for f in files:
        if f.endswith('.lean'):
            lean.append(os.path.join(d, f)[2:])
lean.sort()
bad = re.compile(r'\b(sorry|admit|native_decide|bv_decide|unsafe|partial)\b|^\s*axiom\b|^\s*set_option\b|\bmaxHeartbeats\b', re.M)
exempt_sorry = {'Challenge.lean'}          # the four deliberate Challenge holes
out = []
nsorry_challenge = 0
for f in lean:
    t = open(f, encoding='utf-8').read()
    if not t.lstrip().startswith('module') and not f.startswith('lakefile'):
        out.append(f'NO module header: {f}')
    if f in exempt_sorry:
        nsorry_challenge = len(re.findall(r'\bsorry\b', t.split('/-! ')[0] if False else t))
        continue
    code = re.sub(r'/-.*?-/', '', t, flags=re.S)   # drop comments/docstrings
    code = re.sub(r'--[^\n]*', '', code)
    for m in bad.finditer(code):
        # the audit/closure diagnostics mention these words in meta code; report them explicitly
        out.append(f'{f}: {m.group(0).strip()}')
lines = {f: sum(1 for _ in open(f, encoding='utf-8')) for f in lean}
big = max(lines, key=lines.get)
# import closure of PoissonDeclumping.lean
def imports(f):
    t = open(f, encoding='utf-8').read()
    return re.findall(r'^(?:public\s+)?import\s+(PoissonDeclumping[\w.]*)', t, re.M)
def path(m):
    return m.replace('.', '/') + '.lean'
seen, stack = set(), ['PoissonDeclumping']
while stack:
    m = stack.pop()
    if m in seen: continue
    seen.add(m)
    p = path(m)
    if os.path.exists(p):
        stack.extend(imports(p))
lib = {f[:-5].replace('/', '.') for f in lean if f.startswith('PoissonDeclumping/')}
lib.add('PoissonDeclumping')
unreached = sorted(lib - seen)
print(f'lean files (excluding .lake): {len(lean)}; largest: {big} ({lines[big]} lines; limit 10000)')
print(f'library modules: {len(lib)}; reachable from PoissonDeclumping.lean: {len(lib & seen)}; unreachable: {unreached}')
print(f'deliberate Challenge holes (`sorry` occurrences in Challenge.lean, incl. docstring mentions): {nsorry_challenge}')
print('findings (proof holes / axioms / set_option / unsafe / partial / missing module header):')
for o in out: print('  ' + o)
print('  (none)' if not out else '')
sys.exit(1 if out else 0)
