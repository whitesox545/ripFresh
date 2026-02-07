#!/usr/bin/env python3
import argparse
import hashlib
import json
import os
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

@dataclass
class RecipeEntry:
    id: str
    slug: str
    pdf_path: str
    sha256: str
    byte_size: int


def sha256_file(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open('rb') as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b''):
            hasher.update(chunk)
    return hasher.hexdigest()


def build_entries(root: Path) -> list[RecipeEntry]:
    entries: list[RecipeEntry] = []
    for dirpath, _, filenames in os.walk(root):
        for filename in filenames:
            if not filename.lower().endswith('.pdf'):
                continue
            file_path = Path(dirpath) / filename
            relative_path = file_path.relative_to(root).as_posix()
            slug = Path(filename).stem
            entry_id = hashlib.sha256(relative_path.encode('utf-8')).hexdigest()
            entries.append(
                RecipeEntry(
                    id=entry_id,
                    slug=slug,
                    pdf_path=relative_path,
                    sha256=sha256_file(file_path),
                    byte_size=file_path.stat().st_size,
                )
            )
    entries.sort(key=lambda item: item.pdf_path)
    return entries


def build_payload(entries: list[RecipeEntry], root: Path) -> dict:
    return {
        "schemaVersion": 1,
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "source": {
            "root": root.name,
            "note": "PDF assets are shipped in the app bundle; PDFs contain the full recipe cards.",
        },
        "recipes": [
            {
                "id": entry.id,
                "slug": entry.slug,
                "pdf": {
                    "path": entry.pdf_path,
                    "sha256": entry.sha256,
                    "byteSize": entry.byte_size,
                },
            }
            for entry in entries
        ],
        "stats": {
            "recipeCount": len(entries),
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    entries = build_entries(args.root)
    payload = build_payload(entries, args.root)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('w', encoding='utf-8') as handle:
        json.dump(payload, handle, ensure_ascii=False, indent=2)


if __name__ == "__main__":
    main()
