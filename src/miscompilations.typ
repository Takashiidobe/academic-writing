== Compiler Bugs

Most people think optimizing compilers are great. For the most part they
are. Compilers can replace code with some other code that’s semantically
similar but better in some way (performance, code density, etc.) but a
compiler isn’t magic, and compilers are programs just like any other.
Thus, they have bugs, lots of them.

Any non-optimizing compiler can compile a language without bugs most of
the time. Since there’s a one-to-one mapping of each function to its
lower-level part, as long as the language itself doesn’t have a bug.

However, most compilers these days are optimizing compilers, so they are
at more liberty to change the characteristics of the program. This opens
up the door to many bugs because compilers and program writers can’t
agree on the characteristics of valid optimizations.

This leads to bugs especially in the context of cryptography. Some
operations, can be exploited in a timing attack. Cryptography library
writers then have to be careful to write operations in a way that
doesn’t leak information to an adversary about its internals. See
@chosenplaintext2017 and @djb2022 for more information. For a more
comprehensive look at compiler miscompilations, take a look at @xu2023.

One way around this is to use a more powerful language that would have
constraints around which optimizations are legal. This makes sense, but
as more compiler optimizations are found, the language itself must
change to accommodate them. This would be hard but not impossible
because you’d be bound to not breaking the programming language or its
optimization API. SQL, for example, went the complete opposite way where
query plans are arbitrarily generated on the fly.

There are other initiatives, like verifying the formal semantics of LLVM
IR, like Vellvm @zhao2012.

#bibliography("miscompilations.bib")
