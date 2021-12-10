# Import Group Ordering

There should be three import groups:

- Standard library
- Everything else
- Local package

This grouping can be applied by `goimports` with the `-local` flag.

Any [gopls](https://github.com/golang/tools/blob/master/gopls/doc/settings.md#local-string)-based IDE and [goland](https://www.jetbrains.com/help/idea/code-style-go.html#imports) can be configured to support this.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
import (
  "fmt"
  "os"
  "go.uber.org/atomic"
  "golang.org/x/sync/errgroup"
  "source.example.com/yourname/yourproject"
)
```

</td><td>

```go
import (
  "fmt"
  "os"

  "go.uber.org/atomic"
  "golang.org/x/sync/errgroup"

  "source.example.com/yourname/yourproject"
)
```

</td></tr>
</tbody></table>
