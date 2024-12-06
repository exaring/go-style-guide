# Avoid Naked Returns

Naked returns hurt readability and make it harder for the IDE to help you (e.g. when highlighting variable usage).

Always list the return values explicitly.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
func foo() (x int, err error) {
  x = 42
  return 
}
```

</td><td>

```go
func foo() (x int, err error) {
  x = 42
  return x, err
}
```

</td></tr>
</tbody></table>
