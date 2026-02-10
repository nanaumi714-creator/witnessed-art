#!/usr/bin/env python3
"""Validate required YAML-like front matter fields in skills/*/SKILL.md."""
from pathlib import Path
import sys

REQUIRED = [
    "name:",
    "description:",
    "version:",
    "owners:",
    "inputs:",
    "outputs:",
    "safety_constraints:",
]


def extract_frontmatter(text: str) -> str:
    lines = text.splitlines()
    if len(lines) < 3 or lines[0].strip() != "---":
        return ""
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            return "\n".join(lines[1:i])
    return ""


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    ok = True
    for skill in sorted((root / "skills").glob("*/SKILL.md")):
        body = skill.read_text(encoding="utf-8")
        front = extract_frontmatter(body)
        if not front:
            print(f"[FAIL] missing front matter: {skill}")
            ok = False
            continue
        for key in REQUIRED:
            if key not in front:
                print(f"[FAIL] missing key '{key}' in {skill}")
                ok = False
    if ok:
        print("[OK] all skill front matter blocks are valid")
        return 0
    return 1


if __name__ == "__main__":
    sys.exit(main())
