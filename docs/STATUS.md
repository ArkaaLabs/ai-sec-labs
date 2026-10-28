# Status and known gaps

Written 2026-10-28. This is scaffolding: it has **not been run end to end**,
because it was authored in an environment with the Docker CLI but no daemon.
Treat everything below as the honest state rather than a finished product.

## Verified

- `docker compose config` parses `docker-compose.yml` without error.
- `make help`, `make labs` and `scripts/lab.py` work.
- Both overlay patches apply cleanly to their pinned upstream commits
  (checked with `git apply --check` against `c300ed5` and `980305e`).

## Not verified

- **No container has ever been built or started from this repo.** The first
  real test is `make setup && make up && make lab LAB=1.2.1`.
- The LLMVault image builds from upstream's Dockerfile; whether it honours
  `OLLAMA_HOST` / `OLLAMA_MODEL` exactly as set in `docker-compose.yml` needs
  confirming against its `config.py`.
- Resource behaviour on a 16GB laptop, especially DVAP plus Ollama together.

## Known gaps

| Item | State |
| --- | --- |
| DVMCP service | Commented out in `docker-compose.yml`. Ref is not pinned to a SHA and we have not confirmed it ships a usable Dockerfile. |
| MCPGoat, Appsecco MCP lab | Not included. **License terms unverified** — read their `LICENSE` before adding either. |
| Original labs (10 of 21) | `status: needs-build` in `catalog/labs.json`. Not in this repo by design; they are course IP and live elsewhere. |
| Progress/scoring | Deliberately not unified. LLMVault writes `data/progress.json`, DVAP uses Postgres, MCPGoat has its own runner. Normalising three progress models is its own project and buys little; each lab keeps its own flags. |

## Design decisions worth knowing

- **Labs get their own localhost ports, not paths behind one proxy.** The
  upstream apps emit absolute URLs for their own assets, so a `/llmvault/`
  prefix breaks their CSS and form posts.
- **Everything binds to `127.0.0.1`.** These are deliberately vulnerable
  targets. Never expose them to a network.
- **DVAP runs from its own compose file**, not ours. Its services carry no
  profiles, so including it would start its whole stack on every `make up`.
  It also mounts the Docker socket, which is root-equivalent on the host —
  that is upstream's documented trade-off, and a reason to start it only when
  a DVAP lab is actually in use.
