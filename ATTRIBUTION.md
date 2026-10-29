# Attribution

The lab host in `host/` is a **derivative work of LLMVault**, vendored and
de-branded. Most of the code in this repository is not ours. This file records
what came from where, and is also how we meet the attribution terms of the
licences involved.

If these labs are useful to you, please star and support the upstream projects.

## LLMVault — Sunil Tripathy ([@CyberSunil](https://github.com/CyberSunil))

- Source: https://github.com/CyberSunil/LLMVault
- Licence: **MIT** — full text retained at [`host/LICENSE`](host/LICENSE) with
  the original copyright line intact.
- Used for: the entire lab host — challenge framework, chat loop, flag sealing,
  scoring, progress, Live Mode, and the 20 Core and Advanced labs that back
  Modules 1.2 and 1.4.

### Trademark notice

LLMVault's [`TRADEMARKS.md`](https://github.com/CyberSunil/LLMVault/blob/main/TRADEMARKS.md)
**excludes its name, logo, branding, artwork, banners, screenshots and
documentation from the MIT grant.** None of those are used here. Specifically
excluded from this repository:

- the LLMVault name and wordmark, anywhere user-visible
- `docs/` in its entirety — banner, demo recordings, preview and card artwork
- `static/img/` — logo, UI icons, panel art, per-category note icons
- `TRADEMARKS.md`, `CITATION.cff`, upstream `NOTICE` and `README.md`

Replacement visuals in `host/static/img/` are original to ARKAA Labs.

### Modifications we made

- Remapped every OWASP category label from the 2025 to the **2026 edition**
  (contributed upstream as [LLMVault#53](https://github.com/CyberSunil/LLMVault/pull/53)).
- Renamed and broadened LLM08 to Hidden Context Exposure, per the 2026 scope.
- Re-branded the application; replaced all visual assets.
- Re-sealed every flag under a different pepper, so flags here do not match
  those in public LLMVault walkthroughs.
- **The encrypted expert tier is not shipped.** Its access key is released by
  the original author on request, which cannot work for a course. The vault
  machinery is retained so ARKAA can seal its own tier; its tests skip while no
  vault is present.

## DVAP — Sonu Chaudhary ([@sonuoffsec](https://github.com/sonuoffsec))

- Source: https://github.com/sonuoffsec/DVAP
- Licence: Apache-2.0
- **No DVAP code is vendored here.** Its platform (Postgres, Redis, Qdrant,
  per-lab containers) is heavier than this course needs. Where Module 1.3
  covers ground DVAP also covers — memory poisoning, tool-output injection,
  multi-agent cascading failure — those labs are reimplemented from scratch as
  challenge modules, and we credit DVAP as the source of the idea.
- We contributed its OWASP remap upstream as
  [DVAP#3](https://github.com/sonuoffsec/DVAP/pull/3).

## DVMCP — [@harishsg993010](https://github.com/harishsg993010)

- Source: https://github.com/harishsg993010/damn-vulnerable-MCP-server
- Licence: MIT
- Intended for Lab 1.3.4 (the MCP risk surface). Not yet enabled: its ref needs
  pinning and its container setup is unconfirmed.

## Deliberately excluded

- **`mcp-security-project/mcp-goat` — GPLv3.** Vendoring it would relicense this
  repository and anything distributed with it. We reference it as reading; we do
  not copy from it.
- **`SabyasachiDhal/MCPGoat` — MIT (label unverified).** A different, unrelated
  project with the same name. Not used; its `LICENSE` file has not been read.
- **Appsecco `vulnerable-mcp-servers-lab` — MIT.** Verified and usable, but not
  currently needed.

## Standards

Category labels follow the **OWASP Top 10 for LLM Applications, 2026 edition**
(published 2026-08-03) and the OWASP Top 10 for Agentic Applications, both from
the OWASP GenAI Security Project — https://genai.owasp.org/
