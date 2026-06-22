#!/usr/bin/env bash
# Install rtl-design + rtl-coding-standards skills to ~/.cursor/skills or current project
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_URL="${RTL_DESIGN_REPO:-}"
BRANCH="${RTL_DESIGN_BRANCH:-main}"
LINK_TO_PROJECT=false
DO_COPY=false
USE_LOCAL=false
INCLUDE_PDF_DOCS=false
SKILL_NAMES=(rtl-design rtl-coding-standards timing-analysis sdc cdc lint testbench help)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_URL="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --link-to-project) LINK_TO_PROJECT=true; shift ;;
    --copy) DO_COPY=true; shift ;;
    --local) USE_LOCAL=true; shift ;;
    --include-pdf-docs) INCLUDE_PDF_DOCS=true; shift ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$REPO_URL" ]]; then
  for cfg in "${SCRIPT_DIR}/repo.config.local.json" "${SCRIPT_DIR}/repo.config.example.json"; do
    if [[ -f "$cfg" ]]; then
      REPO_URL=$(python3 -c "import json; print(json.load(open('$cfg')).get('repoUrl',''))" 2>/dev/null || true)
      [[ -n "$REPO_URL" && "$REPO_URL" != *YOURORG* ]] && break
      REPO_URL=""
    fi
  done
fi

if $LINK_TO_PROJECT; then
  SKILLS_DEST="$(pwd)/.cursor/skills"
else
  SKILLS_DEST="${HOME}/.cursor/skills"
fi
mkdir -p "$SKILLS_DEST"

install_skill() {
  local name="$1"
  local src="$2"
  local dest="${SKILLS_DEST}/${name}"
  if [[ ! -d "$src" ]]; then
    echo "Missing skill source: $src"
    exit 1
  fi
  rm -rf "$dest"
  if $DO_COPY; then
    cp -R "$src" "$dest"
    echo "Copied $name -> $dest"
  else
    ln -sfn "$src" "$dest"
    echo "Linked $name -> $src"
  fi
}

install_all_from_root() {
  local root="$1"
  for name in "${SKILL_NAMES[@]}"; do
    install_skill "$name" "${root}/.cursor/skills/${name}"
  done
}

apply_slim_sparse_checkout() {
  local repo="$1"
  local slim="${SCRIPT_DIR}/sparse-checkout-slim.list"
  [[ -f "$slim" ]] || return 0
  git -C "$repo" sparse-checkout init --no-cone 2>/dev/null || true
  git -C "$repo" sparse-checkout set --stdin < "$slim"
}

if $USE_LOCAL || [[ -z "$REPO_URL" || "$REPO_URL" == *YOURORG* ]]; then
  install_all_from_root "$REPO_ROOT"
  echo ""
  echo "Done (local repo). Skills: ${SKILL_NAMES[*]}. Restart Cursor."
  exit 0
fi

CACHE="${HOME}/.cursor/rtl-design-agent-cache"
if [[ ! -d "$CACHE/.git" ]]; then
  if $INCLUDE_PDF_DOCS; then
    git clone --branch "$BRANCH" --single-branch "$REPO_URL" "$CACHE"
  else
    git clone --filter=blob:none --sparse --branch "$BRANCH" --single-branch "$REPO_URL" "$CACHE"
    apply_slim_sparse_checkout "$CACHE"
    echo "Slim cache clone (no PDFs). Use --include-pdf-docs for full docs."
  fi
else
  git -C "$CACHE" fetch origin "$BRANCH"
  git -C "$CACHE" checkout "$BRANCH"
  git -C "$CACHE" pull origin "$BRANCH"
fi

install_all_from_root "$CACHE"
echo ""
echo "Done. Skills: ${SKILL_NAMES[*]}. Restart Cursor. Re-run after git pull to refresh."
