# Status and known gaps

Written 2026-10-29. Honest state, not marketing.

## Verified

- **The lab host runs.** Flask app boots; `/`, `/play`, `/lab/<id>`,
  `/scoreboard`, `/live` and `/completion` all return 200.
- **Test suite passes: 32 passed, 9 skipped, 0 failed.** The 9 skips are the
  expert-tier tests, which skip while no vault is shipped.
- **All 20 Core + Advanced labs load** and their flags decode under the new
  pepper, using the `ARKAA{...}` prefix.
- **Zero upstream brand strings reach any rendered page.** Checked across all
  six page routes.
- **2026 OWASP labels render** (`/lab/llm06` -> `LLM03:2026 Excessive Agency`).
- `docker compose config` parses; `make help`, `make labs` and `scripts/lab.py`
  work.

## Not verified

- **No container has ever been built or started.** The host has only been run
  directly with Python, because this work was done without a Docker daemon.
  First real test: `make up && make lab LAB=1.2.1`.
- The `Dockerfile` is unbuilt. Gunicorn is pinned to one worker on purpose
  (in-process scoreboard), but that has not been exercised.
- Live Mode against the shared Ollama service. The wiring is set via
  `OLLAMA_HOST`, unconfirmed end to end.
- The replacement SVG assets have not been viewed in a browser.

## Track 1 coverage

| | Count |
| --- | --- |
| Ready | 11 |
| Needs building | 9 |
| Unverified upstream | 1 |

Of the 11 ready: 7 are vendored labs in this repo, 4 are the Module 1.1
worksheets in the private pack.

## Known gaps

| Item | State |
| --- | --- |
| Agent harness + tiny RAG | Not built. **Six labs depend on these two pieces.** |
| Labs 1.3.2, 1.3.3, 1.4.3 | Were DVAP-backed. DVAP is no longer shipped, so these need reimplementing as range modules. |
| Lab 1.3.4 (MCP) | DVMCP not enabled: ref unpinned, container setup unconfirmed. |
| Capstone | Not built. |
| Expert tier | Not shipped; machinery retained for a future ARKAA-sealed tier. |

## Decisions worth knowing

- **DVAP is not vendored.** Its platform is heavier than the course needs and
  its labs do not port to a scripted challenge model without rewriting. Its
  concepts are reimplemented and credited.
- **Flags are re-sealed** under a pepper that differs from upstream's, so public
  LLMVault walkthroughs do not yield working answers. The default is still
  public: set `ARKAA_PEPPER` for a paid cohort and re-seal.
- **Everything binds to 127.0.0.1.** These are deliberately vulnerable targets.
- **Upstream reseal tool has a bug** we worked around: its regex is single-line,
  so it silently skipped 3 of 20 flag boxes whose call wrapped across lines, and
  missed a second box in a module that had two. Worth reporting upstream.

## Resource cost per command

| Command | Cost |
| --- | --- |
| `make up` | One nginx container. Negligible. |
| `make lab LAB=1.1.x` | Nothing — worksheets. |
| `make lab LAB=1.2.x` | The range container (Flask). Light. **No model.** |
| `make model` | ~4.7 GB download, held in RAM. Opt in only. |
| `make lab LAB=1.4.1` | Range + Ollama. The only Track 1 lab needing a model. |
