This repository holds the [Exaring Go Style Guide](style.md), which documents
patterns and conventions used in Go code at Exaring.

It is based on the [Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md).

For AI coding agents, a condensed one-line-per-rule version is generated as
[style-for-agents.md](style-for-agents.md) — include it in your agent
instructions (e.g. `CLAUDE.md` or `AGENTS.md`).

Both files are generated from the sources in `src/`; run `make` after editing.
The agent variant of each rule lives in an `<!-- agent: ... -->` comment at the
bottom of the rule's `src/*.md` file.
