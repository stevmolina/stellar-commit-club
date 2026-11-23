# Stellar Commit Club kit 💜

Construí en **Stellar Testnet** con tu agente de IA, sin pelearte con Stellar, git ni GitHub. Sin plata real.

Hecho para **The Commit Club** de BAF × Stellar: Proof of Gratitude (Buenos Aires, 23 nov 2026). Todo termina en el mismo lugar: tu firma en [**Proof of Gratitude**](https://github.com/mariaelisaaraya/Proof-of-Gratitude), la vida de Stellar semana a semana.

Una sola skill: **`/stellar-guide`**. Tu agente te pregunta qué querés hacer y te guía paso a paso:

- **Mi primer commit**: arma tu firma en Proof of Gratitude y abre el PR.
- **Lendara** o **mi proyecto**: de cualquier cambio a un PR revisable (revisa que no haya claves, rama, commit, fork).
- **Solo una idea**: de una frase a un contrato Soroban en Testnet, una página en GitHub Pages y un link de prueba on-chain.
- **Aprender**: responde con fuentes oficiales.

Usa y te muestra los recursos oficiales: la **skill de Stellar** ([stellar/stellar-dev-skill](https://github.com/stellar/stellar-dev-skill)), el **Stellar Docs MCP** (`https://developers.stellar.org/mcp`), **[Raven](https://raven.stellar.buzz/)**, **[Soroban Common Mistakes](https://github.com/mariaelisaaraya/stellar-security-guide)**, Lendara y el catálogo de integraciones.

## Instalar

### Claude Code
```
/plugin marketplace add stevmolina/stellar-commit-club
/plugin install commit-club@stellar-commit-club
/plugin install stellar-dev@stellar-commit-club
```
Reiniciá Claude Code y escribí `/stellar-guide`. Si ya instalaste `stellar-dev` desde las slides, saltá la última línea.

### Codex, Cursor y otros agentes
```bash
curl -fsSL https://raw.githubusercontent.com/stevmolina/stellar-commit-club/main/install.sh | bash
```
Después pedile a tu agente: "usá la skill stellar-guide".

### ¿Sin agente o sin Git?
Seguí el camino web de las slides: en el [repo del evento](https://github.com/mariaelisaaraya/Proof-of-Gratitude), **Add file → Create new file** en `src/content/community/`, copiá la plantilla y **Propose changes**. O abrí el [starter](https://github.com/stevmolina/proof-of-thanks-starter) en GitHub Codespaces, que ya trae todo instalado.

## Los tres caminos

| Camino | Con el kit | Tu firma |
|---|---|---|
| 01 Mi primer commit | `/stellar-guide first-commit`: te pregunta cuándo conociste Stellar y a quién agradecés, y arma tu archivo. | Tu punto en la semana en que conociste Stellar |
| 02 Lendara | Probá o mejorá [Anchor](https://github.com/Lendara-Org/Lendara-monorepo) o [Shield](https://github.com/Lendara-Org/lendara-shield), después `/stellar-guide lendara`. | Tu entrada con `tu_proyecto` y `commits_hoy` |
| 03 Mi proyecto | `/stellar-guide` en tu repo, o con solo una idea para arrancar uno de cero. | Tu entrada con `tu_proyecto` y `commits_hoy` |

Las dos preguntas de las slides también están en el kit: **«¿Ya existe?»** (antes de construir, el agente busca piezas como Lendara o el catálogo de integraciones) y **«Si le saco Stellar, ¿deja de funcionar?»** (la guía se asegura de que el contrato haga algo que importa).

## Qué necesitás

- Una cuenta de GitHub. El agente te loguea con un código en el navegador.
- Compu con git y Node 22.12+. El agente instala Rust y la Stellar CLI (la primera vez baja unos 200 MB). En Windows, o si algo falla, usá **GitHub Codespaces**.
- Para usar las apps en el navegador: [Freighter](https://www.freighter.app) en **Testnet**.

## Estructura

```
.claude-plugin/marketplace.json   # este repo es un marketplace de Claude Code
plugin/
  skills/stellar-guide/SKILL.md          # la guía (una sola skill)
  skills/stellar-guide/references/       # build.md y pr-and-sign.md
  .mcp.json                       # Stellar Docs MCP
install.sh                        # instalador para Codex, Cursor y otros
```

La plantilla de proyecto está en [stevmolina/proof-of-thanks-starter](https://github.com/stevmolina/proof-of-thanks-starter).
