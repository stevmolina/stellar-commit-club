---
name: commit-club
description: Turn whatever the user changed into a clean, reviewable GitHub pull request and log it as Commit Club evidence, handling fork, branch, commit, push and PR for them. Use when the user runs /commit-club, or says they want to submit, send, open a PR for, or register their contribution, commit or change at the Commit Club / BAF × Stellar event.
argument-hint: "[optional: lendara | own-project | first-commit | stellarize]"
---

# /commit-club: change → reviewable PR → logged evidence

The user may know nothing about git. You do every step and explain in one short line each. Speak their language (Spanish if they write in Spanish).

## Hard rules

- **Never merge, force-push, rewrite history on `main`, or delete branches/repos.** You only open PRs for review.
- **Never commit secrets.** Before every commit run the secret check below; if it finds anything, unstage it, add it to `.gitignore`, and tell the user.
- Testnet only. Never real keys or money.
- One logical change per PR. If the working tree mixes unrelated changes, ask which one to send, or split into separate PRs.

## Steps

### 1. GitHub ready
`gh auth status`. If not signed in: `gh auth login --hostname github.com --git-protocol https --web`, tell the user to open the link and paste the code, then `gh auth setup-git`. Make sure `git config user.name`/`user.email` are set (use `gh api user --jq .login` and `<login>@users.noreply.github.com`).

### 2. Understand the change
- `git status --short`, `git diff --stat`, `git remote -v`, current branch.
- No repo or no changes? Ask what they worked on. If they haven't changed anything yet, suggest a starter task for their path (see "Paths") and stop until there's a change.
- Read the diff so you can describe it in plain words.

### 3. Secret check (always)
```bash
git diff HEAD --name-only; git ls-files --others --exclude-standard
git diff HEAD | grep -nE 'S[A-Z2-7]{55}|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|seed phrase|mnemonic|PRIVATE_KEY=|SECRET' || echo clean
```
`S` + 55 base32 chars is a Stellar secret key. Also refuse to commit `.env`, `*.secret`, `identity/*.toml`.

### 4. Classify
- **Path** (`$ARGUMENTS` if given, else infer, else ask once): `first-commit` (event / gratitude repo), `lendara` (any repo under `Lendara-Org`), `own-project`, `stellarize` (repo made with /stellarize).
- **Category**: `docs` if every changed file is docs/text/images (`*.md`, `*.mdx`, `*.txt`, `docs/**` text, images, translations); otherwise `technical` (code, tests, contracts, config). Docs contributions are welcome but are **not** counted as Stellar technical commits; say so kindly if relevant.

### 5. Branch, commit, push, PR
```bash
LOGIN=$(gh api user --jq .login)
BR="commit-club/<short-slug>"
git switch -c "$BR"                      # if on main/master
git add <only the files for this change>
git commit -m "<type>(<scope>): <what, imperative, ≤ 60 chars>"
```
Use conventional types: `feat`, `fix`, `docs`, `test`, `chore`, `i18n`.

Push target:
- Check write access: `gh repo view --json viewerPermission --jq .viewerPermission`. `ADMIN`/`MAINTAIN`/`WRITE` → push to `origin`.
- Otherwise fork: `gh repo fork --remote --remote-name fork` (keeps `origin` as upstream), then `git push -u fork "$BR"`.

Open the PR against the upstream default branch:
```bash
gh pr create --title "<commit title>" --body "<body>"
```
Body template:
```
## What
<1–3 plain sentences>

## Why
<the problem it solves / who it helps>

## How to test
<steps or commands>

---
Made at **The Commit Club** · BAF × Stellar: Proof of Gratitude 💜
Path: <path> · Category: <category>
```
For `stellarize` repos (user owns a brand-new repo), a direct push to `main` is fine; use the latest commit URL as evidence instead of a PR.

### 6. Log the evidence
Add one comment to the shared Commit Club log issue (any GitHub user can comment on it, so there are no conflicts):
```bash
LOG_REPO=stevmolina/stellar-commit-club
ISSUE=$(gh issue list -R "$LOG_REPO" --label commit-club-log --state open --json number --jq '.[0].number')
gh issue comment "$ISSUE" -R "$LOG_REPO" --body "$(cat <<EOF
<!-- commit-club-entry -->
| field | value |
|---|---|
| github | @$LOGIN |
| path | <path> |
| category | <technical/docs> |
| evidence | <PR or commit URL> |
| repo | <owner/repo> |
| status | open |
| summary | <one line> |
EOF
)"
```
If the issue can't be found or commenting fails, don't block: print the same table and tell the user to show it to a mentor (Steven or Elisa).

### 7. Hand-off
```
✅ ¡Contribución enviada!
• PR: <url>
• Registro: <comment url>
Mostrale el link a Steven o Elisa para la validación.
```

## Paths: starter ideas if the user has no change yet

- **first-commit**: the event repo `mariaelisaaraya/Proof-of-Gratitude`. Follow its README; typically add your own entry file (GitHub user, the week you met Stellar, who you thank and why, your next commit for 2027). If the repo has no instructions yet, use `/stellarize` or the Proof of Thanks starter instead.
- **lendara**: `Lendara-Org/lendara-shield` and other `Lendara-Org` repos: test the Testnet demo, fix a docs gap, add a translation, write a test. Look at open issues first: `gh issue list -R Lendara-Org/lendara-shield`.
- **own-project**: read the repo's README/AGENTS.md, find the smallest valuable change (a test, a bug, a docs gap) and make it.
