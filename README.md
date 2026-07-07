# Stream-iOS

![CI](https://github.com/UllashPodder/Stream-iOS/actions/workflows/ci.yml/badge.svg)
![Swift](https://img.shields.io/badge/Swift-5.10-orange)
![Platform](https://img.shields.io/badge/iOS-17%2B-blue)
![Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen)

A single-screen SwiftUI app that renders an infinite, image-heavy list at a steady frame rate — built to demonstrate production-grade engineering practices, not feature count.

**The premise:** anyone can build a list. This project shows what it takes to make one scroll butter-smooth at scale: custom image caching, downsampling, task cancellation, strict MVVM, TDD, and CI — with **zero third-party dependencies**.

Data source: the public [Rick and Morty API](https://rickandmortyapi.com) (800+ paginated, image-heavy records).

---

## Why zero dependencies

No SDWebImage. No Alamofire. No DI framework.

Every piece of infrastructure here is hand-built to demonstrate the underlying engineering, not library configuration:

- **Image pipeline** — an `actor`-based loader with `NSCache` (memory) + `URLCache` (disk), ImageIO downsampling to render size, and cooperative task cancellation when rows leave the screen.
- **Networking** — protocol-based `APIClient` over `URLSession`, fully mockable, no live network in tests.
- **Dependency injection** — constructor injection wired in a single composition root. A DI framework earns its place when wiring cost exceeds framework cost; on this surface area it doesn't.

## Architecture

MVVM with a strict dependency rule: views know the ViewModel, the ViewModel knows abstractions, nothing knows the view.

```
Stream-iOS/
  App/                    // @main entry, composition root (all wiring lives here)
  Features/
    Characters/           // CharacterListView, CharacterListViewModel, RowView
  Core/
    Networking/           // APIClient protocol, URLSessionAPIClient, Endpoint
    ImageLoading/         // ImageLoader actor, downsampling, cache policy
    Models/               // Codable domain models, PagedResponse
  Resources/
Stream-iOSTests/          // ViewModel, pagination, decoding, networking tests
.github/workflows/        // CI: build + test + lint on every PR
```

Key implementation choices, and why:

| Choice | Reason |
|---|---|
| `List` over `LazyVStack` | `List` recycles rows (UICollectionView-style). `LazyVStack` retains every created view — memory bloat and jank on 800+ items. |
| No `AsyncImage` | It has no cache; every row re-downloads on reuse. Replaced with a cached, cancellable loader. |
| ImageIO downsampling | Decode at row size, not source size. Decoding cost, not download cost, is what drops frames. |
| `@Observable` + `@MainActor` ViewModel | iOS 17 observation, deterministic main-thread state, zero UI imports — 100% unit-testable. |
| Pagination dedupe guard | `loadNextPageIfNeeded()` is re-entrant safe; fast scrolling can't trigger duplicate page fetches. |

## Testing

TDD on everything below the view layer. The view is thin by design; the logic is where the tests live.

- **ViewModel** — state transitions (`idle → loading → loaded / error`), pagination triggers, retry.
- **Pagination** — page tracking, next-page resolution, double-fetch protection.
- **Networking / decoding** — fixture-based `Codable` tests, endpoint construction, error mapping.
- **No live network in tests.** All I/O behind protocols, mocked at the seam.

Run locally:

```bash
xcodebuild test -scheme Stream-iOS -destination 'platform=iOS Simulator,name=iPhone 15'
```

## CI/CD and code review

- **GitHub Actions** runs build + tests + SwiftLint on every PR to `main`. `main` is branch-protected; nothing merges red.
- **Every phase of the build was a real PR** with a description, self-review, and conventional commits (`feat:`, `test:`, `ci:`). The PR history documents the engineering process, not just the result.

## Performance (measured, not claimed)

<!-- Fill after Instruments profiling — do not ship this section empty -->

| Metric | Result |
|---|---|
| Scroll frame rate (flick scrolling, Instruments) | _TBD_ |
| Memory at 800+ loaded rows | _TBD_ |
| Cache hit rate after first full scroll | _TBD_ |

Screenshots of the Instruments traces live in `/docs/perf/`.

## Roadmap

- [x] Phase 0 — repo, CI pipeline, lint, branch protection
- [ ] Phase 1 — models + networking (TDD)
- [ ] Phase 2 — pagination logic (TDD)
- [ ] Phase 3 — ViewModel (TDD)
- [ ] Phase 4 — List UI + infinite scroll
- [ ] Phase 5 — custom image pipeline
- [ ] Phase 6 — skeletons, error states, Instruments profiling
- [ ] Phase 7 — extract `StreamImageKit` as a standalone Swift Package

## Requirements

- Xcode 15+
- iOS 17+
- No package resolution needed — there are no dependencies.

## Licence

MIT
