# Pass `context.Context` explicitly

Functions that perform I/O, block, or run on behalf of a request should accept
a [`context.Context`] as their first parameter, conventionally named `ctx`:

  [`context.Context`]: https://pkg.go.dev/context

```go
func (s *Server) FetchUser(ctx context.Context, id string) (*User, error)
```

- Do not store a `Context` in a struct; pass it explicitly to each method that
  needs it. The exception is a struct that represents a single request or task,
  whose lifetime matches the context's.
- Never pass a `nil` context. If you are unsure which context to use, pass
  [`context.TODO`].
- Use context `Value`s only for request-scoped metadata that transits process
  and API boundaries (trace IDs, auth tokens), never to pass optional
  parameters to functions. Use regular arguments for anything the function
  needs to do its job.
- Respect cancellation: long-running loops should check `ctx.Done()` or pass
  `ctx` on to the blocking calls they make.

  [`context.TODO`]: https://pkg.go.dev/context#TODO

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
type Worker struct {
  ctx context.Context // hidden dependency
}

func (w *Worker) Fetch(id string) error {
  return w.get(w.ctx, id)
}
```

</td><td>

```go
type Worker struct {
  // ...
}

func (w *Worker) Fetch(ctx context.Context, id string) error {
  return w.get(ctx, id)
}
```

</td></tr>
</tbody></table>

See also [Contexts and structs] on the Go blog.

  [Contexts and structs]: https://go.dev/blog/context-and-structs

<!-- agent: Functions doing I/O or request-scoped work take `ctx context.Context` as their first parameter. Never store a context in a struct, never pass nil (use `context.TODO()` when unsure), and use context values only for request-scoped metadata (trace IDs, auth), never for optional parameters. -->
