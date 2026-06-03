"""One-off extract: Design Recommendations.pdf -> section outline + raw text dump."""
from pathlib import Path
from pypdf import PdfReader

PDF = Path(__file__).resolve().parents[1] / "docs/standards/Design Recommendations.pdf"
OUT = Path(__file__).resolve().parents[1] / "docs/standards/_pdf_extract_raw.txt"

def main():
    r = PdfReader(str(PDF))
    parts = [f"# Raw extract ({len(r.pages)} pages)\n", f"Source: {PDF.name}\n\n"]
    for i, p in enumerate(r.pages):
        t = p.extract_text() or ""
        parts.append(f"\n\n--- PAGE {i + 1} ---\n\n")
        parts.append(t)
    OUT.write_text("".join(parts), encoding="utf-8")
    print("wrote", OUT, "chars", sum(len(x) for x in parts))

if __name__ == "__main__":
    main()
