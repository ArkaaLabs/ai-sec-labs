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

## Resource cost per command

Relevant if your machine is already loaded. Nothing here starts a model unless
you ask for it.

| Command | What it costs |
| --- | --- |
| `make setup` | Git clones only. No containers. Minutes, little RAM. |
| `make up` | One `nginx:alpine` container (~50 MB image). Negligible. |
| `make lab LAB=1.2.x` | Builds and runs LLMVault (Python/Flask). Light. **No model.** |
| `make model` | Downloads ~4.7 GB and holds the model in RAM. Opt in only. |
| `make lab LAB=1.4.1` | LLMVault Live Mode — the one Track 1 lab that needs the model. |
| `make lab LAB=1.3.x` | Starts DVAP's full stack: Postgres, Redis, Qdrant, API, web, nginx. **Heaviest thing here.** Upstream asks for 16 GB on its own. |

Only `1.4.1` activates the `model` profile. LLMVault's Core and Advanced labs
are scripted assistants and never call a model, which is why Modules 1.2 runs
model-free.

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
