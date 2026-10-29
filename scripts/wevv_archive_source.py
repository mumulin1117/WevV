"""Read excluded, line-commented archive text for offline historical checks only."""
from pathlib import Path


def read_archive(path: Path) -> str:
    text = path.read_text()
    marker = "// ARCHIVE_SOURCE_BEGIN\n"
    if marker not in text:
        return text
    payload = text.split(marker, 1)[1]
    lines = payload.splitlines(keepends=True)
    if not all(line.startswith("//") for line in lines):
        raise ValueError(f"Archive contains uncommented payload: {path}")
    return "".join(line[2:] for line in lines)
