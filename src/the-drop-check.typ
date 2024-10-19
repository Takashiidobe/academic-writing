@bibliography("the-drop-check.bib")

== The Drop Check
Paraphrased from @rustnomicon2024

The drop check lets us learn more about lifetimes in Rust. If we have
code like:

```rust
let x;
let y;
```

We know that variables are dropped in the reverse order of their
definition, and for fields of structs and tuples, in the order of their
definition.

So in this code, the left vec is dropped first:

```rust
let tuple = (vec![], vec![]);
```

However, the borrower checker still treats both vectors as living the
#strong[exact] same amount of time:

Imagine code like this:

```rust
struct Inspector<'a>(&'a u8);

struct World<'a> {
    inspector: Option<Inspector<'a>>,
    days: Box<u8>,
}

fn main() {
    let mut world = World {
        inspector: None,
        days: Box::new(1),
    };
    world.inspector = Some(Inspector(&world.days));
}
```

But a destructor can break its compilation:

```rust
impl<'a> Drop for Inspector<'a> {
    fn drop(&mut self) {
        // This line tries to access data (self.0) that might have
        // already been dropped.
        println!("I was only {} days from retirement!", self.0);
    }
}
```

This problem exists only on types with generic arguments, because
non-generic types have ’static lifetimes, which last forever, so the
borrow checker need not worry about accessing that data during a drop.

If we explicitly have a static lifetime, and try to access static data,
the borrow checker will disallow access like so, even if we’re accessing
static data.

```rust
struct Inspector<'a>(&'a u8, &'static str);

impl<'a> Drop for Inspector<'a> {
    fn drop(&mut self) {
        println!("Inspector(_, {}) knows when *not* to inspect.", self.1);
    }
}

struct World<'a> {
    inspector: Option<Inspector<'a>>,
    days: Box<u8>,
}

fn main() {
    let mut world = World {
        inspector: None,
        days: Box::new(1),
    };
    world.inspector = Some(Inspector(&world.days, "gadget"));
    // Let's say `days` happens to get dropped first.
    // Even when Inspector is dropped, its destructor will not access the
    // borrowed `days`.
}
```

There’s an attribute called `may_dangle` which allows authors to assert
that a generic type’s destructor is guaranteed to not access expired
data, thus, this compiles:

```rust
struct Inspector<'a>(&'a u8, &'static str);

impl<'a> Drop for Inspector<'a> {
    fn drop(&mut self) {
        println!("Inspector(_, {}) knows when *not* to inspect.", self.1);
    }
}

struct World<'a> {
    inspector: Option<Inspector<'a>>,
    days: Box<u8>,
}

fn main() {
    let mut world = World {
        inspector: None,
        days: Box::new(1),
    };
    world.inspector = Some(Inspector(&world.days, "gadget"));
    // Let's say `days` happens to get dropped first.
    // Even when Inspector is dropped, its destructor will not access the
    // borrowed `days`.
}
```
