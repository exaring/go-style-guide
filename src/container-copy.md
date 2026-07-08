# Copy Slices and Maps at Boundaries

Slices and maps contain pointers to the underlying data so be wary of scenarios
when they need to be copied.

## Receiving Slices and Maps

Keep in mind that users can modify a map or slice you received as an argument
if you store a reference to it.

<table>
<thead><tr><th>Bad</th> <th>Good</th></tr></thead>
<tbody>
<tr>
<td>

```go
func (d *Driver) SetTrips(trips []Trip) {
  d.trips = trips
}

trips := ...
d1.SetTrips(trips)

// Did you mean to modify d1.trips?
trips[0] = ...
```

</td>
<td>

```go
func (d *Driver) SetTrips(trips []Trip) {
  d.trips = slices.Clone(trips)
}

trips := ...
d1.SetTrips(trips)

// We can now modify trips[0] without affecting d1.trips.
trips[0] = ...
```

</td>
</tr>

</tbody>
</table>

## Returning Slices and Maps

Similarly, be wary of user modifications to maps or slices exposing internal
state.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
type Stats struct {
  mu sync.Mutex
  counters map[string]int
}

// Snapshot returns the current stats.
func (s *Stats) Snapshot() map[string]int {
  s.mu.Lock()
  defer s.mu.Unlock()

  return s.counters
}

// snapshot is no longer protected by the mutex, so any
// access to the snapshot is subject to data races.
snapshot := stats.Snapshot()
```

</td><td>

```go
type Stats struct {
  mu sync.Mutex
  counters map[string]int
}

func (s *Stats) Snapshot() map[string]int {
  s.mu.Lock()
  defer s.mu.Unlock()

  return maps.Clone(s.counters)
}

// Snapshot is now a copy.
snapshot := stats.Snapshot()
```

</td></tr>
</tbody></table>

Note that [`slices.Clone`] and [`maps.Clone`] create *shallow* copies: if the
elements themselves contain pointers, slices, or maps, those still refer to
shared data.

  [`slices.Clone`]: https://pkg.go.dev/slices#Clone
  [`maps.Clone`]: https://pkg.go.dev/maps#Clone

<!-- agent: Copy slices and maps at API boundaries (`slices.Clone`, `maps.Clone`): copy what you receive before storing it, and copy internal state before returning it, so callers cannot mutate it. Both are shallow copies. -->
