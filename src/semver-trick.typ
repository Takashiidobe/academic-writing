#bibliography("semver-trick.bib")
== The Semver Trick
<the-semver-trick>
This paraphrases the original repo here:
@dtolnay2022

Rust libraries frequently have a problem where they might need to change
the type of a less frequently used public type:

```rust
// Library version 0.1
pub type widely_used = i32;
pub const uncommonly_used: i32 = 2;
```

`widely_used` is depended upon by many downstream crates, whereas
`uncommonly_used` is not. However, it turns out that `uncommonly_used`
was the wrong type, it was always supposed to be `u32`. Say we fix this
one type:

```rust
// Library version 0.2
pub type widely_used = i32;
pub const uncommonly_used: u32 = 2;
```

Unfortunately, this requires a new version of the library, and all
consumers that use `widely_used` have to update their dependency graph,
all because `uncommonly_used` was changed. To avoid this, we do the
following:

+ Make the breaking change, bumping the semver version to one
  major/minor version + 1.
+ Update the 0.1 version to have a dependency on itself on version + 1
  and then export the type from version + 1:

```toml
[package]
name = "library"
version = "0.1.1"

[dependencies]
library = "0.2"  # future version of itself
```

```rust
// library version 0.2
pub use library::widely_used;  // re-export from version + 1

pub const uncommonly_used: u32 = 2;
```

This allows users who used `widely_used` to use either library version
0.1 or 0.2’s version. Of course, if they used uncommonly\_used, they
must wait for all their dependents to upgrade, but now widely used types
are not caught in the crossfire of updates for uncommonly used types.
