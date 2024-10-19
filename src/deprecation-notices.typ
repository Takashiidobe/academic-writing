#bibliography("deprecation-notices.bib")
== Deprecation in Rust
<deprecation-in-rust>
To denote a type or function as deprecated in Rust, use the
`#[deprecated]` attribute:

```rust
#[deprecated(since="0.1.0", note="Please use stable_fn instead")]
fn deprecated_fn(a: i32) -> i32 {
    1
}

fn stable_fn(a: i32) -> i32 {
    0
}
```

For more notes, read the rust reference:
@rustreference2024

== Deprecation in C/C++
<deprecation-in-cc>
C23/C++14 includes a deprecated attribute that works just like Rust’s:

```c
#include <stdio.h>

[[deprecated]]
void TriassicPeriod(void) {
    puts("Triassic Period: [251.9 - 208.5] million years ago.");
}

[[deprecated("Use NeogenePeriod() instead.")]]
void JurassicPeriod(void) {
    puts("Jurassic Period: [201.3 - 152.1] million years ago.");
}

enum { A [[deprecated]], B [[deprecated("Don't use this field")]] = 2 };
```

For more notes, read @cppreference2024
