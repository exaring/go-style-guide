# Introduction

Styles are the conventions that govern our code. The term style is a bit of a
misnomer, since these conventions cover far more than just source file
formatting—gofmt handles that for us.

The goal of this guide is to manage this complexity by describing in detail the
Dos and Don'ts of writing Go code at Exaring. These rules exist to keep the
code base manageable while still allowing engineers to use Go language features
productively.

This guide is a fork of the [Uber Go Style Guide], originally created by
[Prashant Varanasi] and [Simon Newton], adapted to Exaring's needs.

  [Uber Go Style Guide]: https://github.com/uber-go/guide
  [Prashant Varanasi]: https://github.com/prashantv
  [Simon Newton]: https://github.com/nomis52

This documents idiomatic conventions in Go code that we follow. A lot
of these are general guidelines for Go, while others extend upon external
resources:

1. [Effective Go](https://go.dev/doc/effective_go)
2. [Go Common Mistakes](https://go.dev/wiki/CommonMistakes)
3. [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)

We aim for the code samples to be accurate for the two most recent minor versions
of Go [releases](https://go.dev/doc/devel/release).

All code should be error-free when run through `go vet` and
[`staticcheck`](https://staticcheck.dev/). We recommend setting up your editor
to:

- Run `goimports` on save
- Use [`gopls`](https://pkg.go.dev/golang.org/x/tools/gopls) to surface
  analysis findings as you type

