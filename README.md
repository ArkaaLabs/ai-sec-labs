# ai-sec-labs

One app, one command, every lab in one place. A de-branded derivative of
LLMVault carrying a structured AI-security curriculum, kept current with the
**OWASP Top 10 for LLM Applications 2026 edition**.

> **These are deliberately vulnerable applications.** Everything binds to
> `127.0.0.1` and must stay that way. Run them on a machine you control, never
> on a shared or internet-reachable host.

## What this is, and is not

The lab host in `host/` is a **derivative of LLMVault (MIT)**, de-branded and
extended. Most of the code is not ours — see [ATTRIBUTION.md](ATTRIBUTION.md)
for what came from where, and for the trademark terms we respect.

It exists because running several vulnerable-AI projects means several clones,
several setups, several model downloads and several UIs to switch between. That
friction is the single biggest reason people abandon hands-on labs. One host
removes it.

## Requirements

- Docker 24+ with Compose v2
- Git, Python 3, GNU Make
- 16 GB RAM (Ollama holds the model in memory; DVAP asks for 16 GB on its own)
- ~20 GB free disk

## Quick start

```bash
cp .env.example .env         # optional: only if a port clashes
make up                      # start the catalog
make lab LAB=1.2.1           # start the range; no model needed
```

Most labs are **scripted and need no model at all.** Only Live Mode labs do:

```bash
make model                   # ~4.7GB, once, shared by every lab that needs one
make lab LAB=1.4.1
```

Catalog: <http://127.0.0.1:8088>

```bash
make labs      # list every lab and its status
make status    # what is currently running
make down      # stop everything
```

## How it is put together

```
host/                 the lab host — de-branded LLMVault derivative, one container
catalog/labs.json     curriculum map — single source of truth for UI and CLI
docker-compose.yml    every service behind a profile; nothing runs by default
scripts/              lab resolution and (for fetched sources) overlays
upstream.manifest     sources fetched rather than vendored
```

Four decisions carry the weight:

1. **One application, not several.** Vendoring LLMVault and reimplementing the
   labs we want from elsewhere means one UI, one progress store, one login. A
   learner never switches stacks mid-session.
2. **Scripted labs need no model.** Most of Module 1.2 runs with no Ollama at
   all, so a laptop is not holding 4.7 GB of weights to do a prompt-injection
   exercise.
3. **Profiles plus lazy start.** `make lab` brings up only what that lab needs.
4. **Flags re-sealed.** Upstream's published flags do not work here, so a
   learner who finds an LLMVault walkthrough does not get the answer.

## Status

**The host runs and is tested; no container has been built yet.** The Flask app
boots, serves every page, and passes its suite (32 passed, 9 skipped) — but it
has only been run directly, not through Docker. Read
[docs/STATUS.md](docs/STATUS.md) for exactly what is verified and what is not.

Track 1 is **11 of 21 labs ready.** The rest are original course content; the
catalog marks which ship here and which ship in the paid pack.

## Contributing upstream first

Where a fix belongs in an upstream project, it goes there. The OWASP 2026
remaps applied in `host/` were also submitted as
[LLMVault#53](https://github.com/CyberSunil/LLMVault/pull/53) and
[DVAP#3](https://github.com/sonuoffsec/DVAP/pull/3); when either merges, the
corresponding patch is deleted and the pin bumped.

## License

Apache 2.0 — see [LICENSE](LICENSE) and [NOTICE](NOTICE). Upstream projects
retain their own licenses.
