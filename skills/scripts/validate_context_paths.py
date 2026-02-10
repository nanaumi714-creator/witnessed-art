#!/usr/bin/env python3
"""Validate that context path references in SKILL.md inputs exist."""
from pathlib import Path
import re
import sys

PATTERN = re.compile(r"`(context/[a-zA-Z0-9_./-]+\.md)`")


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    ok = True
    for skill in sorted((root / "skills").glob("*/SKILL.md")):
        text = skill.read_text(encoding="utf-8")
        paths = PATTERN.findall(text)
        if not paths:
            print(f"[WARN] no context references found: {skill}")
            continue
        for rel in paths:
            if not (root / rel).exists():
                print(f"[FAIL] missing context path in {skill}: {rel}")
                ok = False
    if ok:
        print("[OK] all referenced context paths exist")
        return 0
    return 1


if __name__ == "__main__":
    sys.exit(main())
