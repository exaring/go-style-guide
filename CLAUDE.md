# Repository Guidelines

## Project Structure & Module Organization
- `src/` holds the rule Markdown; keep one guideline per file and maintain order in `src/SUMMARY.md`.
- `style.md` is the generated handbook—recreate it after edits instead of touching it directly.
- `style-for-agents.md` is also generated: each rule file ends with a one-line `<!-- agent: ... -->` comment, which `tools/gen-style-for-agents.sh` collects in `SUMMARY.md` order. Every new rule must include one.
- `bin/` is reserved for build artifacts such as `stitchmd`; avoid checking in ad-hoc binaries.

## Build, Test, and Development Commands
- `make all` installs `stitchmd` when needed and regenerates `style.md` and `style-for-agents.md` from the curated sources.
- `make lint` reruns the generators in diff mode so you can catch mismatches before CI does.
- `go install go.abhg.dev/stitchmd@latest` refreshes the toolchain manually; thanks to `GOBIN`, the binary lands in `bin/`.

## Coding Style & Naming Conventions
- Write new content in Markdown with level-1 headings for rule titles, short paragraphs, and explicit `Bad` vs `Good` examples.
- Mirror the direct tone already used in `src/`, keep code blocks gofmt-formatted, and favour active voice over hedging.
- Use inline backticks for filenames, packages, and commands; reserve HTML tables for side-by-side comparisons as the guide currently does.

## Testing Guidelines
- Treat `make lint` as the required regression check; it fails whenever `style.md` or `style-for-agents.md` and `src/` drift apart.
- After large edits (new sections or renames), open the rebuilt `style.md` to ensure navigation and anchors produced by `SUMMARY.md` still read correctly.

## Commit & Pull Request Guidelines
- Use the Conventional Commit prefixes already present (`feat:`, `chore:`, `docs:`) and keep each commit focused on one rule or tooling change.
- Commit the regenerated `style.md` alongside the source edits so reviewers see the rendered effect and CI stays green.
- In pull requests, summarise the impacted sections, mention tooling updates, and link supporting issues; add screenshots only when you tweak rendered tables.

## Editing Workflow Tips
- When adding a guideline, place the file in `src/`, register it in `src/SUMMARY.md`, then run `make all`.
- For quick copy edits, adjust the relevant `src/*.md` file, rebuild, and review `git diff` to confirm only intentional text changed.
