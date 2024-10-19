== Static Dispatch
<static-dispatch>
Static dispatch is what C++ and Rust do for generics. They monomorphize
a general function or struct into the specialized ones at runtime.

== Dynamic Dispatch
<dynamic-dispatch>
Dynamic dispatch uses virtual functions, which allow derived classes to
override base class methods. This requires a virtual table lookup, and
is harder to optimize (since the compiler doesn’t know what method is
going to end up being called until runtime).

It seems like static dispatch is better for performance, but it comes at
a cost where every invocation of a generic function/type with a
different set of types requires another copy of the function/type. This
can increase memory size on disk and usage in-memory when running the
program. There’s a special cache for L1 resident data (the instruction
cache, L1i) which is rather small but fast for fetching data from. If
dynamic dispatch allows the desired method to hang around in L1i cache,
it can be faster than static dispatch, if there are many methods that
might get pushed in and out of L1i cache, since a vtable lookup isn’t
that slow compared to an L1 cache miss. As well, the branch predictor
can also optimize away most of the overhead.

But first, profile!
