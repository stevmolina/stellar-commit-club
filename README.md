# Stellar Commit Club kit 💜

Ship on **Stellar Testnet** with your AI coding agent, without thinking about Stellar, git or GitHub.

Built for **The Commit Club** at BAF × Stellar: Proof of Gratitude (Buenos Aires, Nov 23 2026).

| Command | What it does |
|---|---|
| `/stellarize [idea]` | Idea in plain words → Soroban contract deployed on Testnet + web page on GitHub Pages + GitHub repo + on-chain proof link. |
| `/commit-club` | Whatever you changed → secret check → branch, commit, fork if needed → reviewable PR → logged as event evidence. |

Also installs the **official Stellar skill** ([stellar/stellar-dev-skill](https://github.com/stellar/stellar-dev-skill)) and the **Stellar Docs MCP** (`https://developers.stellar.org/mcp`), so your agent uses up-to-date Stellar knowledge. Testnet only, no real money, no sign-ins besides GitHub.

## Install

### Claude Code
```
/plugin marketplace add stevmolina/stellar-commit-club
/plugin install commit-club@stellar-commit-club
/plugin install stellar-dev@stellar-commit-club
```
Then restart Claude Code and type `/stellarize`.

### Codex, Cursor and other agents
```bash
curl -fsSL https://raw.githubusercontent.com/stevmolina/stellar-commit-club/main/install.sh | bash
```
Then ask your agent: "use the stellarize skill to build …".

### No agent?
Use the browser path at the event, or open the starter in Codespaces: [proof-of-thanks-starter](https://github.com/stevmolina/proof-of-thanks-starter).

## What you need

- A GitHub account (the agent signs you in with a browser code).
- A laptop with git and Node 22.12+. The agent installs Rust and the Stellar CLI for you. On Windows, or if anything fails, use **GitHub Codespaces**: everything is preinstalled.
- To use the dApps in the browser: [Freighter](https://www.freighter.app) set to **Testnet**.

## How it fits the Commit Club paths

| Path | Use |
|---|---|
| 1. Mi primer commit | Browser path on the event repo; `/commit-club` if you have an agent. |
| 2. Lendara | Make a change in a `Lendara-Org` repo, then `/commit-club lendara`. |
| 3. Mi proyecto | `/commit-club own-project` on your repo, or `/stellarize` to start one from zero. |

Evidence is logged as a comment on the [Commit Club log issue](../../issues?q=label%3Acommit-club-log): GitHub user, path, technical or docs, PR/commit link, status.

## Layout

```
.claude-plugin/marketplace.json   # this repo is a Claude Code marketplace
plugin/                           # the commit-club plugin
  skills/stellarize/SKILL.md
  skills/commit-club/SKILL.md
  .mcp.json                       # Stellar Docs MCP
install.sh                        # installer for non-Claude agents
```

The project template lives in [stevmolina/proof-of-thanks-starter](https://github.com/stevmolina/proof-of-thanks-starter).
