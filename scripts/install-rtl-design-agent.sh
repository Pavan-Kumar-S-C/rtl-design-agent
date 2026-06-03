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
SKILL_NAMES=(rtl-design rtl-coding-standards)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_URL="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --link-to-project) LINK_TO_PROJECT=true; shift ;;
    --copy) DO_COPY=true; shift ;;
    --local) USE_LOCAL=true; shift ;;
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

if $USE_LOCAL || [[ -z "$REPO_URL" || "$REPO_URL" == *YOURORG* ]]; then
  install_all_from_root "$REPO_ROOT"
  echo ""
  echo "Done (local repo). Skills: ${SKILL_NAMES[*]}. Restart Cursor."
  exit 0
fi

CACHE="${HOME}/.cursor/rtl-design-agent-cache"
if [[ ! -d "$CACHE/.git" ]]; then
  git clone --branch "$BRANCH" --single-branch "$REPO_URL" "$CACHE"
else
  git -C "$CACHE" fetch origin "$BRANCH"
  git -C "$CACHE" checkout "$BRANCH"
  git -C "$CACHE" pull origin "$BRANCH"
fi

install_all_from_root "$CACHE"
echo ""
echo "Done. Skills: ${SKILL_NAMES[*]}. Restart Cursor. Re-run after git pull to refresh."
