"""Extract megafunctions UG PDF to UTF-8 (maintainer). Alias: extract_megafunctions_ug.py"""
from pathlib import Path
from pypdf import PdfReader

STANDARDS = Path(__file__).resolve().parents[1] / "docs" / "standards"
PDF = STANDARDS / "ug_intro_to_megafunctions-683102-848730.pdf"
OUT = STANDARDS / "_megafunctions_extract_raw.txt"


def main():
    pdf = PDF
    if not pdf.is_file():
        print("Missing", pdf)
        return 1
    r = PdfReader(str(pdf))
    parts = [f"# Raw extract ({len(r.pages)} pages)\nSource: {pdf.name}\n\n"]
    for i, page in enumerate(r.pages):
        parts.append(f"\n--- PAGE {i + 1} ---\n\n")
        parts.append(page.extract_text() or "")
    OUT.write_text("".join(parts), encoding="utf-8")
    print("wrote", OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
