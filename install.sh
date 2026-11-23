#!/usr/bin/env bash
# Installs the Commit Club skills for agents that read ~/.agents/skills
# (OpenAI Codex, and others following the Agent Skills standard) and Cursor.
set -euo pipefail
tmp=$(mktemp -d)
git clone --depth 1 -q https://github.com/stevmolina/stellar-commit-club "$tmp/kit"
git clone --depth 1 -q https://github.com/stellar/stellar-dev-skill "$tmp/stellar"
for dest in "$HOME/.agents/skills" "$HOME/.cursor/skills"; do
  mkdir -p "$dest"
  cp -R "$tmp/kit/plugin/skills/"* "$dest/"
  rm -rf "$dest/stellar-dev-skill" && cp -R "$tmp/stellar" "$dest/stellar-dev-skill"
done
rm -rf "$tmp"
echo "✅ Installed stellarize, commit-club and the official Stellar skill."
echo "Optional: add the Stellar Docs MCP server at https://developers.stellar.org/mcp in your agent's MCP settings."
