#!/usr/bin/env bash
# Apply slim sparse-checkout to current repo (drop PDFs from working tree).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SLIM_LIST="${SCRIPT_DIR}/sparse-checkout-slim.list"

cd "$REPO_ROOT"
git sparse-checkout init --no-cone
git sparse-checkout set --stdin < "$SLIM_LIST"

PDF_COUNT=$(find docs/standards -maxdepth 1 -name '*.pdf' 2>/dev/null | wc -l | tr -d ' ')
echo "Slim checkout applied. PDFs on disk: ${PDF_COUNT}."
echo "To restore PDFs later: git sparse-checkout add 'docs/standards/*.pdf'"
