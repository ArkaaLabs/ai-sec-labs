#!/usr/bin/env bash
# Clone each upstream source at its pinned ref into upstream/<name>/.
# Idempotent: re-running checks out the pinned ref again, discarding any
# local edits inside upstream/ (that directory is not yours to edit).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/upstream.manifest"
DEST="$ROOT/upstream"

[ -f "$MANIFEST" ] || { echo "missing $MANIFEST" >&2; exit 1; }
mkdir -p "$DEST"

warned=0
while IFS=$'\t' read -r name url ref license; do
  case "${name:-}" in ''|'#'*) continue ;; esac

  if ! [[ "$ref" =~ ^[0-9a-f]{40}$ ]]; then
    echo "WARNING: $name is pinned to '$ref', not a commit SHA. Upstream can change under you." >&2
    warned=1
  fi

  target="$DEST/$name"
  if [ -d "$target/.git" ]; then
    echo "==> $name: fetching $ref"
    git -C "$target" fetch --depth 1 origin "$ref" 2>/dev/null \
      || git -C "$target" fetch origin
  else
    echo "==> $name: cloning"
    rm -rf "$target"
    git clone --filter=blob:none --no-checkout "$url" "$target"
    git -C "$target" fetch --depth 1 origin "$ref" 2>/dev/null || true
  fi

  git -C "$target" checkout --quiet --force --detach "$ref" 2>/dev/null \
    || git -C "$target" checkout --quiet --force --detach "origin/$ref"

  echo "    $name @ $(git -C "$target" rev-parse --short HEAD)  [$license]"
done < "$MANIFEST"

[ "$warned" -eq 1 ] && echo && echo "Pin the warned refs in upstream.manifest before you rely on them."
echo
echo "Done. Next: make overlays"
