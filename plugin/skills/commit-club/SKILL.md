---
name: commit-club
description: Turn whatever the user changed into a clean, reviewable GitHub pull request and sign it on the event's Proof of Gratitude wall, handling fork, branch, commit, push and PR for them. Use when the user runs /commit-club, or says they want to submit, send, open a PR for, or register their contribution, commit or change at the Commit Club / BAF × Stellar event.
argument-hint: "[optional: lendara | own-project | first-commit | stellarize]"
---

# /commit-club: change → reviewable PR → your dot on Proof of Gratitude

The user may know nothing about git. You do every step and explain in one short line each. Speak their language (Spanish if they write in Spanish).

## Hard rules

- **Never merge, force-push, rewrite history on `main`, or delete branches/repos.** You only open PRs for review.
- **Never commit secrets.** Before every commit run the secret check below; if it finds anything, unstage it, add it to `.gitignore`, and tell the user.
- Testnet only. Never real keys or money.
- One logical change per PR. If the working tree mixes unrelated changes, ask which one to send, or split into separate PRs.

## Steps

### 1. GitHub ready
If `gh` is missing: macOS `brew install gh`, Windows `winget install GitHub.cli`, Linux the release tarball from https://github.com/cli/cli/releases into `~/.local/bin`.

Sign in without blocking (a foreground login would hang):
```bash
gh auth status || { (gh auth login --hostname github.com --git-protocol https --web > /tmp/gh-login.txt 2>&1 &); sleep 3; cat /tmp/gh-login.txt; }
```
Show the user the one-time code and `https://github.com/login/device`, poll `gh auth status` every 5 s (up to 3 min), then `gh auth setup-git`. Make sure `git config user.name`/`user.email` are set (use `gh api user --jq .login` and `<login>@users.noreply.github.com`).

### 2. Understand the change
- `git status --short`, `git diff --stat`, `git remote -v`, current branch.
- No local clone yet (common for `first-commit` and `lendara`)? `gh repo fork <owner/repo> --clone --remote` and work there; `origin` becomes their fork and `upstream` the original.
- No repo or no changes? Ask what they worked on. If they haven't changed anything yet, suggest a starter task for their path (see "Paths") and stop until there's a change.
- Read the diff so you can describe it in plain words.

### 3. Secret check (always)
```bash
git add -N .            # make new (untracked, non-ignored) files visible to diff
git diff HEAD --name-only
git diff HEAD | grep -nE 'S[A-Z2-7]{55}|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|seed phrase|mnemonic|PRIVATE_KEY=|SECRET' || echo clean
```
`S` + 55 base32 chars is a Stellar secret key. Also refuse to commit `.env*`, `*.secret`, `.stellar/`, `identity/*.toml`. Never use `git add -f` on ignored files. Run the same check again on `git diff --cached` right before committing.

### 4. Classify
- **Path** (`$ARGUMENTS` if given, else infer from the upstream repo):
  - `first-commit`: **only** the event repo `mariaelisaaraya/Proof-of-Gratitude`.
  - `lendara`: any repo under `Lendara-Org`.
  - `stellarize`: a repo created by /stellarize (from the `proof-of-thanks-starter` template) that the user owns.
  - `own-project`: everything else.
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
- Otherwise fork: `gh repo fork --remote --remote-name fork` (keeps `origin` as upstream), then `git push -u fork "$BR"`. (If you cloned with `gh repo fork --clone`, the fork is already `origin`: push there.)

Open the PR against the upstream default branch, always explicit (non-interactive shells can't answer gh's prompts):
```bash
UP=<upstream owner/repo>          # the original repo, not the fork
BASE=$(gh repo view "$UP" --json defaultBranchRef --jq .defaultBranchRef.name)
gh repo set-default "$UP"
gh pr create --repo "$UP" --base "$BASE" --head "$LOGIN:$BR" --title "<commit title>" --body "<body>"
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

### 6. Sign the event wall (Proof of Gratitude)
The event's single record is the repo **`mariaelisaaraya/Proof-of-Gratitude`**: one JSON file per person in `src/content/community/`, and each merged PR lights up a dot on https://mariaelisaaraya.github.io/Proof-of-Gratitude/. Every path ends here.

- **`first-commit`**: the entry file *is* the contribution. Do it in step 5 directly on that repo (see "Entry file" below).
- **`lendara`, `own-project`, `stellarize`**: after their PR/commit, add (or update) their entry with `tu_proyecto` (one line about the project) and `commits_hoy` (link to the PR, or to `https://github.com/<owner>/<repo>/commits?author=<login>`). Offer to add a thank-you too (`agradece_a`, `por_que`, `proximo_paso`).

```bash
UP=mariaelisaaraya/Proof-of-Gratitude
F="src/content/community/$LOGIN.json"
gh api "repos/$UP/contents/$F" --jq .content 2>/dev/null | base64 -d   # existing entry? then edit it instead of creating
```
Work in a fork (`gh repo fork $UP --clone --remote`, branch `firma/$LOGIN`), commit `feat(community): add <nombre>` (or `update`), push, and open the PR with the explicit `gh pr create --repo $UP …` from step 5.

#### Entry file (exact format, validated by the repo's build)
```json
{
  "nombre": "Nombre o apodo",
  "conoci_stellar": "AAAA-MM-DD",
  "github": "usuario",
  "agradece_a": "a …",
  "por_que": "…",
  "proximo_paso": "…",
  "tu_proyecto": "…",
  "commits_hoy": "https://github.com/…",
  "redes": "https://…"
}
```
- Required: `nombre`, `conoci_stellar`, `github`. **Delete optional fields the user leaves empty** (an empty string fails validation).
- `conoci_stellar`: when they *met Stellar* (not today), `AAAA-MM-DD`, between `2014-07-28` and today. Only month/year known → use day `01`.
- `github`: username only, letters/digits/hyphens, no `@` or URL.
- `agradece_a` must read as what follows "Agradece": start with `a`, `al` or `a la` ("a Juana, que me ayudó con…").
- `commits_hoy` and `redes` must be full `https://` URLs.
- Ask for the fields in one friendly message (name, when they met Stellar, who they thank and why, what's next). Validate before committing; if their build check fails on the PR, read the error (`gh pr checks`) and fix it.
- Never touch `data/hitos.json` (curated by the maintainers) or anyone else's file.

If anything here fails, don't block: give the user the JSON and the link to the repo's browser flow (Add file → Create new file in `src/content/community/`), the same steps the slides show.

### 7. Hand-off
```
✅ ¡Contribución enviada!
• Tu cambio: <PR or commit url>
• Tu firma en Proof of Gratitude: <PR url>  (cuando se mergee, se prende tu punto)
Mostrale los links a Steven o Elisa.
```

## Paths: starter ideas if the user has no change yet

These match the three paths on the event slides ("Mi primer commit", "Lendara", "Mi proyecto").

- **01 Mi primer commit**: your entry file in `mariaelisaaraya/Proof-of-Gratitude` (step 6). Follow its `CONTRIBUTING.md`.
- **02 Lendara** (Testnet, no real money): **Anchor** = `Lendara-Org/Lendara-monorepo` (local currency → USDC on-ramp, sandbox with test cards, demo https://lendara-monorepo-fixh.vercel.app/es) and **Shield** = `Lendara-Org/lendara-shield` (compliant privacy, demo https://lendara-shield.duckdns.org/). Ideas: try the demo and fix what confused you, improve docs, add a translation (ES/EN/PT), write a test, or integrate one into your project. Check open issues first: `gh issue list -R <repo>`.
- **03 Mi proyecto**: read the repo's README/AGENTS.md and make the smallest valuable change (a test, a bug, a docs gap). Ask the slides' question with them: "Si le saco Stellar, ¿deja de funcionar?" If not, help them find the one thing Stellar really does in their project; that can be the contribution. No project yet? Use `/stellarize`.
