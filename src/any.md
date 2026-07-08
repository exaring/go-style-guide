# Use `any` instead of `interface{}`

Since Go 1.18, `any` is an alias for `interface{}`. Prefer `any` in all new
code: it is shorter and reads as intent ("any value") rather than mechanism.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
func Print(values ...interface{}) {
  // ...
}

var cache map[string]interface{}
```

</td><td>

```go
func Print(values ...any) {
  // ...
}

var cache map[string]any
```

</td></tr>
</tbody></table>

Also consider whether `any` is needed at all: since Go supports generics, a
type parameter often expresses the intent better and keeps type safety.

<!-- agent: Write `any`, never `interface{}` (alias since Go 1.18). Consider a generic type parameter instead of `any` where it preserves type safety. -->
