#!/usr/bin/env bash
# Generates style-for-agents.md from the `<!-- agent: ... -->` one-liners
# embedded in the src/*.md rule files, in src/SUMMARY.md order.
#
# Usage: tools/gen-style-for-agents.sh [output-file]
set -euo pipefail

cd "$(dirname "$0")/.."
out="${1:-style-for-agents.md}"

{
  cat <<'EOF'
<!--
  This file was generated from the files in the "src" directory.
  DO NOT EDIT. To make changes, edit the `agent:` comment in the
  relevant src/*.md file and run `make`.
-->

# Exaring Go Style Guide for AI Coding Agents

This is the condensed, one-rule-per-line version of the
[Exaring Go Style Guide](style.md), meant to be included in the instructions
of AI coding agents. Every rule applies unless it conflicts with the
conventions of the surrounding code — consistency wins. See the full guide
for rationale and examples.

EOF

  grep -oE '\([a-z-]+\.md\)' src/SUMMARY.md | tr -d '()' | while read -r f; do
    rule=$(sed -n 's/^<!-- agent: \(.*\) -->$/\1/p' "src/$f")
    [[ -z "$rule" ]] && continue
    title=$(sed -n 's/^# \(.*\)$/\1/p' "src/$f" | head -n1)
    printf -- '- **%s**: %s\n' "$title" "$rule"
  done
} > "$out"
