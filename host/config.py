"""Global config for the ARKAA AI Security Range.

Built on LLMVault by Sunil Tripathy (MIT). See ATTRIBUTION.md. The LLMVault
name, logo and artwork are excluded from that MIT grant by its TRADEMARKS.md
and are deliberately not used here.
"""

# --- Branding (single source of truth; changing these renames the whole app) ---
APP_NAME = "ARKAA AI Security Range"
APP_EMOJI = "\U0001F6E1"

AUTHOR = "ARKAA Labs"
COPYRIGHT_YEAR = "2026"
COPYRIGHT = f"\u00a9 {COPYRIGHT_YEAR} {AUTHOR}"

# Flag format.
FLAG_PREFIX = "ARKAA"

# Pepper used to seal challenge flags at rest (see challenges/__init__.py: seal/unseal).
#
# This default differs from upstream LLMVault's, so the flags in this range do NOT
# match the ones in public LLMVault walkthroughs. That is the point: a learner who
# searches for an upstream writeup does not get a working answer.
#
# It is still a PUBLIC default, so it protects against copy-paste, not against a
# determined source-reader. For a paid cohort, set ARKAA_PEPPER in the environment
# and re-seal:  ARKAA_PEPPER=... python -m tools.sealtool reseal-flags
import os as _os_pepper
FLAG_PEPPER = _os_pepper.environ.get(
    "ARKAA_PEPPER",
    _os_pepper.environ.get("LLMVAULT_PEPPER", "arkaa-range::default-pepper::v1"),
)

# Key that seals the instructor SOLUTION vault (challenges/solutions.enc).
# Deliberately has NO default: unset => the app runs normally and the sealed
# solutions cannot be decrypted by anyone reading the source.
SOLUTION_KEY = _os_pepper.environ.get("ARKAA_SOLUTION_KEY") or _os_pepper.environ.get("LLMVAULT_SOLUTION_KEY")

REPO_URL = "https://github.com/ArkaaLabs/ai-sec-labs"
AUTHOR_HANDLE = "ArkaaLabs"

# Scoring
HINT_COSTS = [10, 25, 50]  # escalating cost per hint: 1st -10, 2nd -25, 3rd -50
HINT_PENALTY = HINT_COSTS[0]  # kept for backwards compat / reference

# Where per-player progress is saved so it survives refresh AND restart.
# Self-host friendly: a plain JSON file, no database needed. In Docker, mount a
# volume at /app/data to keep it across container recreation.
DATA_FILE = "data/progress.json"

SECRET_KEY = _os_pepper.environ.get("ARKAA_SECRET_KEY", "change-me-for-anything-public")  # only used for local session cookies

# ---------------------------------------------------------------------------
# Live Mode — real local models instead of scripted bots.
#
# Live Mode is additive: if none of this is reachable, Play Mode is completely
# unaffected and the Live section simply shows setup instructions instead of
# labs. Nothing below adds a Python dependency — Ollama is spoken to over plain
# HTTP using the standard library.
# ---------------------------------------------------------------------------
import os as _os

LIVE_MODE_ENABLED = True

# Where your local Ollama server listens. Override with the OLLAMA_HOST env var
# if you run it on another port or inside Docker (e.g. http://host.docker.internal:11434).
OLLAMA_HOST = _os.environ.get("OLLAMA_HOST", "http://localhost:11434")

# The model the shipped scenario prompts were written and tuned against. If you
# don't have it pulled, the dropdown falls back to whatever you do have — but
# scenario difficulty is only calibrated for this one.
#   ollama pull qwen2.5:3b-instruct
OLLAMA_DEFAULT_MODEL = _os.environ.get("OLLAMA_DEFAULT_MODEL", "qwen2.5:3b-instruct")

# How long to wait for a full streamed reply. Generous on purpose: a 3B model on
# CPU is slow, and that is expected rather than an error.
OLLAMA_TIMEOUT = float(_os.environ.get("OLLAMA_TIMEOUT", "180"))

# Optional commercial providers. Left as None unless you export a key, in which
# case extra entries appear in the model dropdown. Check your provider's usage
# policy before adversarial testing — that obligation sits with the key holder.
OPENAI_API_KEY = _os.environ.get("OPENAI_API_KEY")
OPENAI_MODELS = ["gpt-4o-mini"]


# --- Debug mode --------------------------------------------------------------
# Flask's debug mode enables the Werkzeug interactive debugger, which runs
# arbitrary Python for anyone who can reach the server. It is therefore OFF
# unless the operator explicitly opts in: set ARKAA_DEBUG=1 (or true).
def debug_enabled(environ=None) -> bool:
    env = _os.environ if environ is None else environ
    return env.get("ARKAA_DEBUG", env.get("LLMVAULT_DEBUG", "")).strip().lower() in ("1", "true")


DEBUG = debug_enabled()
