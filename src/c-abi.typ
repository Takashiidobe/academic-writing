#bibliography("c-abi.bib")

== The C++ ABI
<the-c-abi>
The ABI (Application Binary Interface) is the bit-for-bit representation
that the types and functions of a language have.

In C++’s case, this includes struct layout, the argument and return
types of a function, the special members of a class, and virtual
functions.

There’s a lot of sentiment to break ABI in C++, because this would allow
performance gains for associative containers, and wouuld’ve removed some
stdlib containers like lock\_guard.

@cor3ntin2020
@meneide2022
@meneide2021

For these reasons, Rust doesn’t have a stable ABI – the compiler is free
to break anything at any time.

Maybe there’s a better way, using symbol versioning.
