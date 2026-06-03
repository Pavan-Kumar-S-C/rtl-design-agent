# Git init and first push (maintainer)

Run these steps **once** to publish this scaffold. Designers only need `git clone` after the repo exists.

## Prerequisites

- [GitHub CLI](https://cli.github.com/) — `gh auth login`
- Git configured with your identity (no repo-specific config changes required)

## Windows (recommended)

```powershell
cd path\to\rtl-design-agent
.\scripts\create-github-repo.ps1 -RepoName rtl-design-agent -Visibility private
```

The script will:

1. `git init` + initial commit if `.git` is missing
2. `gh repo create` with remote `origin`
3. `git push -u origin main`

## Linux / macOS (manual)

```bash
cd rtl-design-agent
git init
git add -A
git commit -m "Initial rtl-design-agent scaffold"
gh repo create rtl-design-agent --private --source=. --remote=origin --push
```

## After publish

1. Copy `scripts/repo.config.example.json` → `scripts/repo.config.local.json` (gitignored).
2. Set `"repoUrl"` to your GitHub clone URL.
3. Share [SETUP.md](../SETUP.md) with designers.

## Teammate refresh

```bash
git pull
bash scripts/install-rtl-design-agent.sh   # or --local if repo is already open
```

Restart Cursor after install.
