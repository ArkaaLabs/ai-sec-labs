#!/usr/bin/env bash
# Apply our patches on top of the pinned upstream checkouts.
#
# Overlays are git patches, not edited copies, so they fail loudly when
# upstream drifts instead of silently masking a change. If a patch no
# longer applies, upstream moved: re-pin, regenerate, or drop the patch
# because it landed upstream.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rc=0

shopt -s nullglob
for dir in "$ROOT"/overlays/*/; do
  name="$(basename "$dir")"
  target="$ROOT/upstream/$name"
  patches=("$dir"*.patch)

  [ ${#patches[@]} -eq 0 ] && continue
  if [ ! -d "$target/.git" ]; then
    echo "SKIP $name: not fetched. Run 'make fetch' first." >&2
    rc=1; continue
  fi

  for p in "${patches[@]}"; do
    if git -C "$target" apply --reverse --check "$p" 2>/dev/null; then
      echo "==> $name: $(basename "$p") already applied"
      continue
    fi
    if git -C "$target" apply --check "$p" 2>/dev/null; then
      git -C "$target" apply "$p"
      echo "==> $name: applied $(basename "$p")"
    else
      echo "FAIL $name: $(basename "$p") does not apply to $(git -C "$target" rev-parse --short HEAD)." >&2
      echo "     Upstream moved, or the change landed upstream. See overlays/README.md." >&2
      rc=1
    fi
  done
done

exit $rc
