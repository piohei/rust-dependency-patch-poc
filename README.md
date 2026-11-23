# Build a Rust dependency from a patch file

This example changes the error message in the published `hex` 0.4.3 crate.
It stores the diff in `patches/hex-0.4.3.patch` and generates the crate source in `.patched/`.

```sh
sh ./prepare.sh && cargo run --locked --offline
```

The program prints `Odd number of hex digits` and asserts that exact message.

1. `prepare.sh` downloads the pinned `.crate` archive from crates.io and checks its SHA-256 against the value recorded in the crates.io index.
2. It extracts the archive into a staging directory and applies the diff with zero fuzz. It publishes the generated crate only after both steps succeed. A rerun compares the fresh result with any existing generated copy.
3. `[patch.crates-io]` in `Cargo.toml` directs Cargo to the generated crate. The ordinary dependency declaration still requests `hex` 0.4.3.

The preparation step needs network access and `curl`, `shasum`, `tar`, and `patch`. Cargo builds this example offline after preparation. The same two commands can run in CI.

To switch back to a registry release, remove the override, change the dependency requirement to the fixed version, and update `Cargo.lock` with `cargo update -p hex`.
