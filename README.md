# ai-sec-labs

One command, one lab at a time. An orchestration layer over open-source
AI-security training ranges, mapped to a structured curriculum and kept current
with the **OWASP Top 10 for LLM Applications 2026 edition**.

> **These are deliberately vulnerable applications.** Everything binds to
> `127.0.0.1` and must stay that way. Run them on a machine you control, never
> on a shared or internet-reachable host.

## What this is, and is not

This repo contributes **setup, a launcher, and a curriculum mapping**. The labs
are other people's work, fetched at pinned commits and run under their own
licenses — see [ATTRIBUTION.md](ATTRIBUTION.md). Nothing upstream is vendored
here.

It exists because running three separate vulnerable-AI projects means three
clones, three setups, three model downloads and three sets of docs. That
friction is the single biggest reason people abandon hands-on labs.

## Requirements

- Docker 24+ with Compose v2
- Git, Python 3, GNU Make
- 16 GB RAM (Ollama holds the model in memory; DVAP asks for 16 GB on its own)
- ~20 GB free disk

## Quick start

```bash
cp .env.example .env         # optional: only if a port clashes
make setup                   # fetch pinned upstreams, apply our overlays
make model                   # one model download, shared by every lab
make up                      # start the catalog
make lab LAB=1.2.1           # start one lab and only what it needs
```

Catalog: <http://127.0.0.1:8088>

```bash
make labs      # list every lab and its status
make status    # what is currently running
make down      # stop everything
```

## How it is put together

```
upstream.manifest     pinned sources (name, url, commit, license)
overlays/             our changes to upstream, as git patches
catalog/labs.json     curriculum map — single source of truth for UI and CLI
docker-compose.yml    every service behind a profile; nothing runs by default
scripts/              fetch, overlay, and lab resolution
```

Four decisions carry the weight:

1. **Pinned commits, never a tracking branch.** Upstream changing under you
   breaks labs silently.
2. **Overlays are patches, not edited files.** When upstream drifts, the patch
   fails loudly rather than masking the change. See
   [overlays/README.md](overlays/README.md).
3. **One shared Ollama.** Each upstream project would otherwise pull its own
   copy of the weights.
4. **Profiles plus lazy start.** `make lab` brings up that lab and its
   dependencies only. Starting everything at once will exhaust a 16 GB laptop.

## Status

**This scaffolding has not been run end to end yet.** Compose parses, the
tooling works, and both overlay patches verify against their pinned bases — but
no container has been built from this repo. Read
[docs/STATUS.md](docs/STATUS.md) before relying on it; it lists what is
verified, what is not, and the known gaps.

## Contributing upstream first

Where a fix belongs in an upstream project, it goes there. The OWASP 2026
remaps carried in `overlays/` were also submitted as
[LLMVault#53](https://github.com/CyberSunil/LLMVault/pull/53) and
[DVAP#3](https://github.com/sonuoffsec/DVAP/pull/3); when either merges, the
corresponding patch is deleted and the pin bumped.

## License

Apache 2.0 — see [LICENSE](LICENSE) and [NOTICE](NOTICE). Upstream projects
retain their own licenses.
