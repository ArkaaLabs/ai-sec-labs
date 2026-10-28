# Attribution

`ai-sec-labs` is an orchestration layer. It contributes setup, a launcher and a
curriculum mapping; **the labs themselves are other people's work.** Nothing
upstream is vendored into this repository — each project is fetched at its
pinned commit into `upstream/` and runs under its own license.

If you find these labs useful, please star and support the upstream projects.

## Upstream projects

### LLMVault — Sunil Tripathy ([@CyberSunil](https://github.com/CyberSunil))
- Source: https://github.com/CyberSunil/LLMVault
- License: MIT (code). **Trademark and branding are explicitly excluded** from
  the MIT grant — see the project's `TRADEMARKS.md`. The LLMVault name, logo,
  artwork, banners and screenshots are not licensed for reuse, and this repo
  does not reuse them.
- Used for: Modules 1.2 and 1.4 — the OWASP LLM Top 10 range and the prompt
  injection labs.

### DVAP (Damn Vulnerable AI Platform) — Sonu Chaudhary ([@sonuoffsec](https://github.com/sonuoffsec))
- Source: https://github.com/sonuoffsec/DVAP
- License: Apache 2.0
- Used for: Module 1.3 — agentic and multi-agent labs.

### DVMCP (Damn Vulnerable Model Context Protocol) — [@harishsg993010](https://github.com/harishsg993010)
- Source: https://github.com/harishsg993010/damn-vulnerable-MCP-server
- License: MIT
- Used for: Module 1.3 — the MCP risk surface. Currently disabled pending a
  pinned commit and a verified container setup (see `docs/STATUS.md`).

## Not included

These were evaluated and left out because we have not verified their license
terms. Read each project's `LICENSE` before adding it:

- MCPGoat — https://github.com/SabyasachiDhal/MCPGoat
- Vulnerable MCP Servers Lab (Appsecco) — https://github.com/appsecco/vulnerable-mcp-servers-lab

## Standards

Category labels follow the **OWASP Top 10 for LLM Applications, 2026 edition**
(published 2026-08-03) from the OWASP GenAI Security Project, and the OWASP
Top 10 for Agentic Applications. See https://genai.owasp.org/

Upstream labelling fixes bringing these projects onto the 2026 edition were
contributed back: [LLMVault#53](https://github.com/CyberSunil/LLMVault/pull/53),
[DVAP#3](https://github.com/sonuoffsec/DVAP/pull/3).
