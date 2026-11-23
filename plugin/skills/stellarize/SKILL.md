---
name: stellarize
description: Turn a plain-language idea into a live Stellar Testnet dApp (Soroban contract + web page on GitHub Pages + GitHub repo) without the user knowing anything about Stellar, git or GitHub. Use when the user runs /stellarize, or says they want to build, start or ship something on Stellar, Soroban or Testnet.
argument-hint: "[your idea in plain words]"
---

# /stellarize: idea → live Stellar Testnet project

You do **all** the technical work. The user only describes an idea and, at most, clicks one GitHub sign-in link. Never ask them to choose libraries, networks, folder names or git commands. Talk to them in their language (Spanish if they write in Spanish), in short, friendly sentences, no jargon.

## Hard rules

- **Testnet only.** Never mainnet, never real money, never ask for a real wallet secret or seed phrase.
- **Never print, paste or commit a secret key.** Keys stay in the Stellar CLI keystore (`stellar keys`). Never run `stellar keys secret` where its output shows up.
- **Start from the starter template**, don't invent a stack: `stevmolina/proof-of-thanks-starter` (Soroban contract `contracts/gratitude` + static page in `docs/` + scripts). Read its `AGENTS.md` after cloning and follow it.
- **Keep scope tiny**: something that works in ~30 minutes. One contract, at most 3 public functions changed or added. If the idea is bigger, build the smallest slice and list the rest as "next steps".
- Never merge PRs, never force-push, never delete repos.
- If a step fails, fix it yourself (read the error, retry, use the official `stellar-dev` skill or the `stellar-docs` MCP). Only hand back to the user for the GitHub sign-in.

## Steps

Track these as a checklist and tell the user one short line per step ("✅ Wallet de prueba lista").

### 1. Get the idea (one question max)
If `$ARGUMENTS` has an idea, use it. Otherwise ask once: "¿Qué querés construir? Contámelo en una frase (ej: 'un frasco de propinas para agradecer a mis amigos')." If they have no idea, propose the template as-is: "Proof of Thanks, agradecimientos públicos en Stellar."

Turn it into: a short repo name (`kebab-case`, ≤ 30 chars, e.g. `tip-jar-stellar`), a one-line pitch, and the minimal contract change (or "no change, just rebrand").

### 2. Basic tools and GitHub
- **Windows** (`uname` shows MINGW/MSYS, or PowerShell): skip local setup, go to "Codespaces" below.
- **macOS**: if `xcode-select -p` fails, run `xcode-select --install` and tell the user to accept the popup (~5 min); wait for it before continuing.
- **gh missing**: macOS `brew install gh`; Linux: download the latest `gh_*_linux_amd64.tar.gz` from https://github.com/cli/cli/releases into `~/.local/bin`. **Node < 22.12 or missing**: install Node LTS (brew/nodejs.org/fnm) instead of stopping.

Sign in (never in the foreground, it would hang):
```bash
gh auth status || { (gh auth login --hostname github.com --git-protocol https --web > /tmp/gh-login.txt 2>&1 &); sleep 3; cat /tmp/gh-login.txt; }
```
Show the user the one-time code from that file and the link `https://github.com/login/device`: "Abrí este link, pegá el código y aprobá. Es lo único que tenés que hacer." Then poll `gh auth status` every 5 s (up to 3 min) until it succeeds, and run `gh auth setup-git`. If `git config user.name` is empty, set it from `gh api user --jq .login` (email `<login>@users.noreply.github.com`).

### 3. Create the repo from the template
```bash
OWNER=$(gh api user --jq .login)
gh repo create "$OWNER/<name>" --template stevmolina/proof-of-thanks-starter --public --clone
cd <name>
```
If the clone is empty (GitHub is still copying), wait 5 s and `git pull origin main`; retry up to 6 times. If the name is taken, add a short suffix.

### 4. Tools and test wallet
```bash
bash scripts/setup.sh
```
It installs Rust, the wasm target and the pinned Stellar CLI if missing (no sudo), and creates a funded Testnet identity called `me`. The first run downloads ~200 MB; tell the user it can take 5–10 minutes on event Wi-Fi.
- Exit code **1**: the message says what to install; do it (or tell the user the one action needed) and rerun.
- Exit code **2** or it fails twice: use **Codespaces** (below).
- If funding failed, retry later with `stellar keys fund me --network testnet` (max 3 tries, 10 s apart). Don't loop on Friendbot.

#### Codespaces (fallback: Windows, no compiler, broken setup)
The repo has a devcontainer that preinstalls everything and runs `setup.sh`.
```bash
gh auth refresh -h github.com -s codespace     # one more browser approval, same flow as step 2
CS=$(gh codespace create -R "$OWNER/<name>" -b main --machine basicLinux32gb 2>/dev/null || gh codespace create -R "$OWNER/<name>" -b main)
gh codespace ssh -c "$CS" -- 'cd /workspaces/<name> && bash scripts/setup.sh'
```
Run every later command through `gh codespace ssh -c "$CS" -- 'cd /workspaces/<name> && …'`. Edit files there with the same command (e.g. heredocs) or tell the user to open it in the browser: `gh codespace view -c "$CS" --web`.

### 5. Adapt the idea
Edit `contracts/gratitude/src/lib.rs` and `src/test.rs` for the idea (keep it small; rename the crate only if it really helps). Add or update at least one unit test per changed function. Then:
```bash
cargo test
```
Loop until green. Update `docs/index.html` (title, copy, form fields) and `docs/gratitude-client.js` so the page matches the contract functions. Keep `docs/` static: no bundler, no new frameworks. Update `README.md` with the pitch.

### 6. Deploy and prove it works
```bash
bash scripts/deploy.sh <crate-name>
node scripts/smoke-test.cjs me
```
`deploy.sh` runs tests, builds with `stellar contract build`, deploys to Testnet, and writes `docs/config.js`. If you changed function names or arguments, update `scripts/smoke-test.cjs` first so it exercises the new write + read path. The smoke test must print `OK` and a Stellar Expert link; that link is the on-chain proof.

### 7. Publish
Commit in small logical steps (contract, page, docs), e.g. `feat(contract): add tip amount`, then:
```bash
git push origin main
gh api -X POST "repos/$OWNER/<name>/pages" -f "source[branch]=main" -f "source[path]=/docs" 2>/dev/null || true
gh api -X POST "repos/$OWNER/<name>/pages/builds" >/dev/null 2>&1 || true   # make sure a build runs
```
Pages URL: `https://$OWNER.github.io/<name>/`. Poll `gh api repos/$OWNER/<name>/pages/builds/latest --jq .status` until `built` (up to ~2 min); then `curl -sI` the URL and check for 200.

### 8. Log it for the Commit Club
Run the `commit-club` skill's **log step** with path `stellarize`, category `technical`, and the repo + latest commit URL as evidence (no extra PR needed: it's their own new repo).

### 9. Hand-off (short!)
```
🚀 ¡Listo! Tu proyecto está en Stellar Testnet.
• Página: https://<owner>.github.io/<name>/
• Código: https://github.com/<owner>/<name>
• Contrato: https://stellar.expert/explorer/testnet/contract/<id>
• Prueba on-chain: <tx link from smoke test>
Para usar la página: instalá Freighter, ponela en Testnet y fondeá tu cuenta con Friendbot (hay un link en la página).
Próximos pasos: <1–3 ideas>
```
