"""Extract ug_intro_to_megafunctions PDF to UTF-8 text."""
from pathlib import Path
from pypdf import PdfReader

PDF = Path(__file__).resolve().parents[1] / "docs/standards/ug_intro_to_megafunctions-683102-848730.pdf"
OUT = Path(__file__).resolve().parents[1] / "docs/standards/_megafunctions_extract_raw.txt"


def main():
    r = PdfReader(str(PDF))
    parts = [f"# Raw extract ({len(r.pages)} pages)\nSource: {PDF.name}\n\n"]
    for i, p in enumerate(r.pages):
        parts.append(f"\n--- PAGE {i + 1} ---\n\n")
        parts.append(p.extract_text() or "")
    OUT.write_text("".join(parts), encoding="utf-8")
    print("wrote", OUT, "pages", len(r.pages))


if __name__ == "__main__":
    main()
