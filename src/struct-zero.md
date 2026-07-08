# Use `var` for Zero Value Structs

When all the fields of a struct are omitted in a declaration, use the `var`
form to declare the struct.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
user := User{}
```

</td><td>

```go
var user User
```

</td></tr>
</tbody></table>

This differentiates zero valued structs from those with non-zero fields
similar to the distinction created for [map initialization], and matches how
we prefer to [declare empty slices].

  [map initialization]: #initializing-maps
  [declare empty slices]: https://go.dev/wiki/CodeReviewComments#declaring-empty-slices

<!-- agent: Declare all-zero structs as `var user User`, not `user := User{}`. -->
