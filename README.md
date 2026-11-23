# Stellar Commit Club kit 💜

Construí en **Stellar Testnet** con tu agente de IA, sin pelearte con Stellar, git ni GitHub. Sin plata real.

Hecho para **The Commit Club** de BAF × Stellar: Proof of Gratitude (Buenos Aires, 23 nov 2026). Todo termina en el mismo lugar: tu firma en [**Proof of Gratitude**](https://github.com/mariaelisaaraya/Proof-of-Gratitude), la vida de Stellar semana a semana.

| Comando | Qué hace |
|---|---|
| `/stellarize [idea]` | De una idea en una frase a un contrato Soroban en Testnet, una página publicada en GitHub Pages, un repo propio y un link de prueba on-chain. |
| `/commit-club` | De cualquier cambio a un PR revisable: revisa que no haya claves, hace la rama, el commit y el fork si hace falta, y deja tu firma en Proof of Gratitude. |

Incluye la **skill oficial de Stellar** ([stellar/stellar-dev-skill](https://github.com/stellar/stellar-dev-skill), la misma de las slides) y el **Stellar Docs MCP** (`https://developers.stellar.org/mcp`), así tu agente responde con contexto oficial y no de memoria.

## Instalar

### Claude Code
```
/plugin marketplace add stevmolina/stellar-commit-club
/plugin install commit-club@stellar-commit-club
/plugin install stellar-dev@stellar-commit-club
```
Reiniciá Claude Code y escribí `/stellarize`. Si ya instalaste `stellar-dev` desde las slides, saltá la última línea.

### Codex, Cursor y otros agentes
```bash
curl -fsSL https://raw.githubusercontent.com/stevmolina/stellar-commit-club/main/install.sh | bash
```
Después pedile a tu agente: "usá la skill stellarize para construir …".

### ¿Sin agente o sin Git?
Seguí el camino web de las slides: en el [repo del evento](https://github.com/mariaelisaaraya/Proof-of-Gratitude), **Add file → Create new file** en `src/content/community/`, copiá la plantilla y **Propose changes**. O abrí el [starter](https://github.com/stevmolina/proof-of-thanks-starter) en GitHub Codespaces, que ya trae todo instalado.

## Los tres caminos

| Camino | Con el kit | Tu firma |
|---|---|---|
| 01 Mi primer commit | `/commit-club first-commit`: te pregunta cuándo conociste Stellar y a quién agradecés, y arma tu archivo. | Tu punto en la semana en que conociste Stellar |
| 02 Lendara | Probá o mejorá [Anchor](https://github.com/Lendara-Org/Lendara-monorepo) o [Shield](https://github.com/Lendara-Org/lendara-shield), después `/commit-club lendara`. | Tu entrada con `tu_proyecto` y `commits_hoy` |
| 03 Mi proyecto | `/commit-club` en tu repo, o `/stellarize` para arrancar uno de cero. | Tu entrada con `tu_proyecto` y `commits_hoy` |

Las dos preguntas de las slides también están en el kit: **«¿Ya existe?»** (antes de construir, el agente busca piezas como Lendara o el catálogo de integraciones) y **«Si le saco Stellar, ¿deja de funcionar?»** (`/stellarize` se asegura de que el contrato haga algo que importa).

## Qué necesitás

- Una cuenta de GitHub. El agente te loguea con un código en el navegador.
- Compu con git y Node 22.12+. El agente instala Rust y la Stellar CLI (la primera vez baja unos 200 MB). En Windows, o si algo falla, usá **GitHub Codespaces**.
- Para usar las apps en el navegador: [Freighter](https://www.freighter.app) en **Testnet**.

## Estructura

```
.claude-plugin/marketplace.json   # este repo es un marketplace de Claude Code
plugin/
  skills/stellarize/SKILL.md
  skills/commit-club/SKILL.md
  .mcp.json                       # Stellar Docs MCP
install.sh                        # instalador para Codex, Cursor y otros
```

La plantilla de proyecto está en [stevmolina/proof-of-thanks-starter](https://github.com/stevmolina/proof-of-thanks-starter).
