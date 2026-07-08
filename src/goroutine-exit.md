# Wait for goroutines to exit

Given a goroutine spawned by the system,
there must be a way to wait for the goroutine to exit.
There are two popular ways to do this:

- Use a `sync.WaitGroup`.
  Do this if there are multiple goroutines that you want to wait for

    ```go
    var wg sync.WaitGroup
    for range N {
      wg.Go(func() {
        // ...
      })
    }

    // To wait for all to finish:
    wg.Wait()
    ```

  ([`WaitGroup.Go`] requires Go 1.25; on older versions, call `wg.Add(1)`
  before spawning the goroutine and `defer wg.Done()` inside it.)

    [`WaitGroup.Go`]: https://pkg.go.dev/sync#WaitGroup.Go

- Add another `chan struct{}` that the goroutine closes when it's done.
  Do this if there's only one goroutine.

    ```go
    done := make(chan struct{})
    go func() {
      defer close(done)
      // ...
    }()

    // To wait for the goroutine to finish:
    <-done
    ```

<!-- agent: Wait for goroutines to exit: `sync.WaitGroup` (use `wg.Go` on Go 1.25+) for several goroutines, or a `done` channel the goroutine closes for a single one. -->
