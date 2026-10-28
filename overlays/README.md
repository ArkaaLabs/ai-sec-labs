# Overlays

Our changes to upstream projects live here as **git patches**, never as edited
copies of upstream files.

## Why patches

`upstream/` is a checkout of someone else's repository at a pinned commit. If we
edited those files in place, the next re-pin would silently clobber our work, or
worse, silently keep it when upstream had already fixed the same thing. A patch
fails loudly instead: `make overlays` tells you when a patch no longer applies,
which is exactly the moment a human should look.

## Layout

```
overlays/<upstream-name>/NNNN-description.patch
```

Applied by `scripts/apply-overlays.sh` (`make overlays`), which is idempotent —
it detects an already-applied patch and skips it.

## Current overlays

| Overlay | What it does | Retire when |
| --- | --- | --- |
| `llmvault/0001-owasp-llm-top10-2026.patch` | Remaps category labels from the OWASP LLM Top 10 2025 edition to 2026 | [CyberSunil/LLMVault#53](https://github.com/CyberSunil/LLMVault/pull/53) merges |
| `dvap/0001-owasp-llm-top10-2026.patch` | Remaps the OWASP category list from the 2023 edition to 2026 | [sonuoffsec/DVAP#3](https://github.com/sonuoffsec/DVAP/pull/3) merges |

Both changes were also submitted upstream. **When a PR merges, delete that
patch and bump the pin in `upstream.manifest`** — do not keep carrying a change
that now exists upstream.

## Regenerating a patch

Work in a clone of the upstream project, commit your change, then:

```bash
git format-patch -1 --stdout > /path/to/ai-sec-labs/overlays/<name>/NNNN-thing.patch
```

Check it applies to the pinned base before committing it:

```bash
git checkout --detach <pinned-sha>
git apply --check /path/to/overlays/<name>/NNNN-thing.patch
```

## What does not belong here

- Anything that should simply be fixed upstream — send a PR instead.
- Our own original labs. Those live in a separate private repository; this repo
  only orchestrates third-party open-source labs.
