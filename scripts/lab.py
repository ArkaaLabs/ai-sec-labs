#!/usr/bin/env python3
"""Resolve a lab id to the compose profiles it needs.

Prints shell-sourceable vars for the Makefile. Keeping the lookup here means
catalog/labs.json stays the single source of truth for both the launcher UI
and the CLI.
"""
import json
import pathlib
import shlex
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
labs = json.loads((ROOT / "catalog" / "labs.json").read_text())["labs"]

if len(sys.argv) < 2:
    sys.exit("usage: lab.py <lab-id>")

wanted = sys.argv[1].strip()
lab = next((l for l in labs if l["id"] == wanted), None)
if lab is None:
    ids = ", ".join(l["id"] for l in labs)
    sys.exit(f"unknown lab '{wanted}'. Known ids: {ids}")

status, stack = lab["status"], lab["stack"]

if status == "needs-build":
    msg = (f"Lab {lab['id']} — {lab['title']}\n"
           f"  Not built yet. Source: {lab['source']}\n"
           f"  Nothing to start.")
elif status == "unverified":
    msg = (f"Lab {lab['id']} — {lab['title']}\n"
           f"  Upstream not verified (see docs/STATUS.md). Source: {lab['source']}\n"
           f"  Its compose service is commented out until that is resolved.")
elif stack == "none":
    msg = (f"Lab {lab['id']} — {lab['title']}\n"
           f"  Worksheet lab, no container needed.")
else:
    where = lab["url"] or "see the lab's own docs"
    msg = (f"Lab {lab['id']} — {lab['title']}\n"
           f"  Open: {where}\n"
           f"  Target: {lab['source']}\n"
           f"  Model: {lab['model']}")

profile_args = " ".join(f"--profile {p}" for p in lab.get("profiles", []))

print(f"STACK={shlex.quote(stack if status == 'ready' else 'none')}")
print(f"PROFILE_ARGS={shlex.quote(profile_args)}")
print(f"MESSAGE={shlex.quote(msg)}")
