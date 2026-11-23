---
name: stellarize
description: Turn a plain-language idea into a live Stellar Testnet dApp (Soroban contract + web page on GitHub Pages + GitHub repo) without the user knowing anything about Stellar, git or GitHub. Use when the user runs /stellarize, or says they want to build, start or ship something on Stellar, Soroban or Testnet.
argument-hint: "[your idea in plain words]"
---

# /stellarize: idea → live Stellar Testnet project

You do **all** the technical work. The user only describes an idea and, at most, clicks one GitHub sign-in link. Never ask them to choose libraries, networks, folder names or git commands. Talk to them in their language (Spanish if they write in Spanish), in short, friendly sentences, no jargon.

## Hard rules

- **Testnet only.** Never mainnet, never real money, never ask for a real wallet secret or seed phrase.
- **Never print, paste or commit a secret key.** Keys stay in the Stellar CLI keystore (`stellar keys`).
- **Start from the starter template**, don't invent a stack: `stevmolina/proof-of-thanks-starter` (Soroban contract `contracts/gratitude` + static page in `docs/` + scripts). Read its `AGENTS.md` after cloning and follow it.
- **Keep scope tiny**: something that works in ~30 minutes. One contract, at most 3 public functions changed or added. If the idea is bigger, build the smallest slice and list the rest as "next steps".
- Never merge PRs, never force-push, never delete repos.
- If a step fails, fix it yourself (read the error, retry, use the official `stellar-dev` skill or the `stellar-docs` MCP). Only hand back to the user for the GitHub sign-in.

## Steps

Track these as a checklist and tell the user one short line per step ("✅ Wallet de prueba lista").

### 1. Get the idea (one question max)
If `$ARGUMENTS` has an idea, use it. Otherwise ask once: "¿Qué querés construir? Contámelo en una frase (ej: 'un frasco de propinas para agradecer a mis amigos')." If they have no idea, propose the template as-is: "Proof of Thanks, agradecimientos públicos en Stellar."

Turn it into: a short repo name (`kebab-case`, ≤ 30 chars, e.g. `tip-jar-stellar`), a one-line pitch, and the minimal contract change (or "no change, just rebrand").

### 2. GitHub ready
```bash
gh auth status
```
If not signed in: run `gh auth login --hostname github.com --git-protocol https --web` and tell the user: "Abrí el link que aparece, pegá el código y aprobá. Es lo único que tenés que hacer." Then `gh auth setup-git`. If `git config user.name` is empty, set it from `gh api user --jq .login` (and email `<login>@users.noreply.github.com`).

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
It installs Rust, the wasm target and the Stellar CLI if missing (no sudo), and creates a funded Testnet identity called `me`.
- If it says no C compiler: on macOS run `xcode-select --install` and tell the user to accept the popup; on Linux without sudo, suggest Codespaces: `gh codespace create -R "$OWNER/<name>" -b main` then `gh codespace code` or the web link. Continue there.
- If Friendbot fails, wait 10 s and run `stellar keys fund me --network testnet`.

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
