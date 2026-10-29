# Overlays

**Empty, and that is the current design.**

The lab host in `host/` is vendored — a de-branded derivative of LLMVault with
our changes already applied to the source. There is no upstream checkout to
patch, so there is nothing here.

This directory and `scripts/apply-overlays.sh` remain because the pattern is
still right for anything we fetch rather than vendor (DVMCP, if it is enabled).
If you add a fetched source and need to modify it, put a git patch at
`overlays/<name>/NNNN-description.patch` and `make overlays` will apply it.

## Where the 2026 remap went

The OWASP LLM Top 10 2026 relabelling was originally carried here as patches
against pinned upstreams. It now lives directly in `host/`, and was also
contributed back upstream:

- [CyberSunil/LLMVault#53](https://github.com/CyberSunil/LLMVault/pull/53)
- [sonuoffsec/DVAP#3](https://github.com/sonuoffsec/DVAP/pull/3)
