#!/usr/bin/env bash
# Clone rtl-design-agent without docs/standards PDFs (~2 MB vs ~70 MB).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="${1:-rtl-design-agent}"
REPO_URL="${RTL_DESIGN_REPO:-}"
BRANCH="${RTL_DESIGN_BRANCH:-main}"
SLIM_LIST="${SCRIPT_DIR}/sparse-checkout-slim.list"

if [[ -z "$REPO_URL" ]]; then
  for cfg in "${SCRIPT_DIR}/repo.config.local.json" "${SCRIPT_DIR}/repo.config.example.json"; do
    if [[ -f "$cfg" ]]; then
      REPO_URL=$(python3 -c "import json; print(json.load(open('$cfg')).get('repoUrl',''))" 2>/dev/null || true)
      [[ -n "$REPO_URL" && "$REPO_URL" != *YOURORG* ]] && break
      REPO_URL=""
    fi
  done
fi
[[ -z "$REPO_URL" ]] && REPO_URL="https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git"

[[ -e "$DEST" ]] && { echo "Destination already exists: $DEST"; exit 1; }

echo "Sparse clone (no PDFs): $REPO_URL -> $DEST"
git clone --filter=blob:none --sparse --branch "$BRANCH" --single-branch "$REPO_URL" "$DEST"
git -C "$DEST" sparse-checkout init --no-cone
git -C "$DEST" sparse-checkout set --stdin < "$SLIM_LIST"

PDF_COUNT=$(find "$DEST/docs/standards" -maxdepth 1 -name '*.pdf' 2>/dev/null | wc -l | tr -d ' ')
MB=$(du -sm "$DEST" | cut -f1)
echo "Done. PDFs on disk: ${PDF_COUNT}. Working tree ~${MB} MB."
echo "Install skills: cd $DEST && ./scripts/install-rtl-design-agent.sh --local"
