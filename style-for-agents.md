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

- **Pointers to Interfaces**: Pass interfaces as values, never as pointers to interfaces (`*io.Reader`); the underlying data can itself be a pointer.
- **Verify Interface Compliance**: Verify interface compliance at compile time with `var _ http.Handler = (*Handler)(nil)` for types whose API contract requires implementing an interface.
- **Receivers and Interfaces**: Pointer-receiver methods are only callable on addressable values, and a type with pointer-receiver methods satisfies interfaces only via its pointer. Value receivers work on both.
- **Zero-value Mutexes are Valid**: Declare mutexes as `var mu sync.Mutex` (the zero value is valid), never `new(sync.Mutex)`. Never embed a mutex in a struct; use an unexported named field like `mu sync.Mutex`.
- **Copy Slices and Maps at Boundaries**: Copy slices and maps at API boundaries (`slices.Clone`, `maps.Clone`): copy what you receive before storing it, and copy internal state before returning it, so callers cannot mutate it. Both are shallow copies.
- **Defer to Clean Up**: Use `defer` to release resources such as files and locks; its overhead is negligible.
- **Channel Size is One or None**: Make channels unbuffered or with a buffer of 1. Any larger size needs strong justification for how the size was chosen and what happens when the buffer fills.
- **Start Enums at One**: Start iota-based enums at one (`iota + 1`) unless the zero value is a deliberate, meaningful default.
- **Use `"time"` to handle time**: Use `time.Time` for instants and `time.Duration` for durations, never bare ints. When a wire format cannot carry them, use int/float with the unit in the field name (e.g. `intervalMillis`) and RFC 3339 strings for timestamps.
- **Pass `context.Context` explicitly**: Functions doing I/O or request-scoped work take `ctx context.Context` as their first parameter. Never store a context in a struct, never pass nil (use `context.TODO()` when unsure), and use context values only for request-scoped metadata (trace IDs, auth), never for optional parameters.
- **Error Types**: For errors callers must match: exported `var ErrFoo = errors.New(...)` for static messages, or a custom `FooError` type for dynamic ones (matched with `errors.Is`/`errors.As`). Otherwise plain `errors.New`/`fmt.Errorf` suffice.
- **Error Wrapping**: When propagating errors, add succinct context with `fmt.Errorf("open config: %w", err)`; avoid "failed to" prefixes. Use `%v` instead of `%w` only to deliberately hide the cause. Combine independent failures with `errors.Join`.
- **Error Naming**: Name error variables `ErrFoo`/`errFoo` and error types `FooError`.
- **Handle Errors Once**: Handle each error exactly once: either wrap and return it, or log it and degrade gracefully. Never log an error and also return it.
- **Handle Type Assertion Failures**: Always use the comma-ok form of type assertions (`t, ok := i.(string)`); the single-value form panics on mismatch.
- **Don't Panic**: Never panic in production code paths; return errors and let callers decide. Panics are acceptable only for unrecoverable situations and program-startup failures (e.g. `template.Must`). In tests, use `t.Fatal`, not panic.
- **Avoid Mutable Globals**: Avoid mutable global variables; inject dependencies instead (e.g. a `now func() time.Time` field rather than swapping a package-level `timeNow`).
- **Avoid Embedding Types in Public Structs**: Do not embed types (structs or interfaces) in public structs: it leaks implementation details and freezes the API. Write explicit delegating methods instead.
- **Avoid Using Built-In Names**: Never use predeclared identifiers (`error`, `string`, `len`, `min`, `max`, ...) as names for variables, fields, or parameters.
- **Avoid `init()`**: Avoid `init()`; initialize explicitly from `main()`. If unavoidable, `init()` must be deterministic and free of I/O, global state access, and side-effect ordering dependencies.
- **Exit in Main**: Call `os.Exit` or `log.Fatal` only inside `main()`; every other function returns errors.
- **Exit Once**: Exit at most once per `main()`: put the logic in `func run() error` and have `main` do `if err := run(); err != nil { log.Fatal(err) }`.
- **Use field tags in marshaled structs**: Every struct field marshaled to JSON, YAML, etc. gets an explicit field tag; the serialized form is a contract that must survive field renames.
- **Don't fire-and-forget goroutines**: Never fire-and-forget goroutines: every goroutine must have a stop signal (or predictable end) and a way to wait for its exit. Test concurrent code with `testing/synctest` (Go 1.25+), which fails on goroutines leaked from its bubble.
- **Wait for goroutines to exit**: Wait for goroutines to exit: `sync.WaitGroup` (use `wg.Go` on Go 1.25+) for several goroutines, or a `done` channel the goroutine closes for a single one.
- **No goroutines in `init()`**: Never spawn goroutines from `init()`. Packages needing background work expose a worker object with a `Close`/`Stop`/`Shutdown` method that stops the goroutine and waits for it.
- **Performance**: The following performance rules apply to hot paths only.
- **Prefer strconv over fmt**: In hot paths, use `strconv` instead of `fmt` to convert primitives to/from strings.
- **Avoid string-to-byte conversion**: Do not convert the same fixed string to `[]byte` repeatedly in a loop; convert once and reuse.
- **Prefer Specifying Container Capacity**: Pass a capacity hint to `make()` for maps (`make(map[K]V, n)`) and slices (`make([]T, 0, n)`) when the size is known, especially before append loops.
- **Avoid overly long lines**: Soft line-length limit: 99 characters; wrap earlier when it reads better, but it is not a hard limit.
- **Be Consistent**: Above all, be consistent: match the conventions of the surrounding code and apply style changes at package level or wider, never file-by-file.
- **Group Similar Declarations**: Group related `const`/`var`/`type` declarations into blocks; keep unrelated declarations in separate blocks. Adjacent local variables declared together go in one `var (...)` block.
- **Import Group Ordering**: Use three import groups separated by blank lines: standard library, external packages, local/company packages (as applied by `goimports -local`).
- **Package Names**: Package names are short, all-lowercase, singular, without underscores, and informative; never `util`, `common`, `shared`, or `lib`.
- **Function Names**: Use MixedCaps for function names; underscores only in test names for grouping (`TestFoo_EdgeCase`).
- **Import Aliasing**: Alias an import only when the package name does not match the last path element (e.g. `trace "example.com/trace/v2"`) or to resolve a conflict.
- **Function Grouping and Ordering**: Order within a file: types, consts/vars, constructor (`NewX`), then methods grouped by receiver in rough call order; exported functions first, plain utility helpers at the end.
- **Reduce Nesting**: Reduce nesting: handle errors and special cases first, then return early or `continue`, keeping the happy path unindented.
- **Unnecessary Else**: Avoid `else` when both branches only assign a variable: assign the default first, then override in an `if`.
- **Top-level Variable Declarations**: For top-level `var`s, omit the type when it equals the expression type (`var _s = F()`); specify it only when they differ (`var _e error = F()`).
- **Embedding in Structs**: Place embedded types at the top of the field list, separated by a blank line. Embed only when it adds real functionality without harming the zero value, copy semantics, or API surface; never embed mutexes.
- **Local Variable Declarations**: Use `:=` when setting an explicit value; use `var` when the zero value is intended (e.g. `var filtered []int` before an append loop).
- **nil is a valid slice**: Return `nil` rather than `[]T{}`; check emptiness with `len(s) == 0`, never `s == nil`; a `var`-declared nil slice is immediately usable with `append`.
- **Reduce Scope of Variables**: Reduce variable scope where it does not add nesting, e.g. `if err := os.WriteFile(...); err != nil { return err }` when `err` is not needed afterwards.
- **Avoid Naked Parameters**: Comment non-obvious literal arguments at call sites (`printInfo("foo", true /* isLocal */)`), or better, replace bare `bool` parameters with dedicated types.
- **Avoid Naked Returns**: Never use naked returns; always list return values explicitly.
- **Use Raw String Literals to Avoid Escaping**: Use raw string literals (backquotes) instead of escaping quotes by hand.
- **Use `any` instead of `interface{}`**: Write `any`, never `interface{}` (alias since Go 1.18). Consider a generic type parameter instead of `any` where it preserves type safety.
- **Use Field Names to Initialize Structs**: Always use field names when initializing structs (vet-enforced); the only exception is test-table literals with three or fewer fields.
- **Omit Zero Value Fields in Structs**: Omit zero-value fields from struct literals unless the name adds meaning (as in test tables).
- **Use `var` for Zero Value Structs**: Declare all-zero structs as `var user User`, not `user := User{}`.
- **Initializing Struct References**: Initialize struct pointers with `&T{...}`, not `new(T)`.
- **Initializing Maps**: Initialize empty or programmatically-filled maps with `make(map[K]V, hint)`; use map literals only for a fixed set of elements.
- **Format Strings outside Printf**: Declare format strings used outside a direct Printf call as `const` so `go vet` can check them.
- **Naming Printf-style Functions**: Name custom Printf-style functions with an `f` suffix (`Wrapf`, not `Wrap`) so `go vet -printfuncs` can check them.
- **Test Tables**: Use table-driven tests with `t.Run` subtests for repetitive logic; name the slice `tests`, each case `tt`, and prefix inputs/outputs with `give`/`want`. If cases need branching logic, mocks, or conditional assertions, write separate test functions instead. Since Go 1.22, no `tt := tt` copy is needed for `t.Parallel()`.
- **Functional Options**: For optional constructor/API arguments, use functional options: an `Option` interface with an unexported method applying to an unexported `options` struct, passed as `opts ...Option`.
