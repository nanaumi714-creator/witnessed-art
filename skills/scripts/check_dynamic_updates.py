#!/usr/bin/env python3
"""Check dynamic operation files for minimum operational readiness."""
from pathlib import Path
import sys

REQUIRED_FILES = [
    "context/dynamic/current_sprint.md",
    "context/dynamic/pending_tasks.md",
    "context/dynamic/decisions_log.md",
    "context/dynamic/open_questions.md",
    "context/dynamic/changelog.md",
]


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    ok = True
    for rel in REQUIRED_FILES:
        file = root / rel
        if not file.exists():
            print(f"[FAIL] required file missing: {rel}")
            ok = False
            continue
        if not file.read_text(encoding="utf-8").strip():
            print(f"[FAIL] required file is empty: {rel}")
            ok = False
    if ok:
        print("[OK] required dynamic files are present and non-empty")
        return 0
    return 1


if __name__ == "__main__":
    sys.exit(main())
