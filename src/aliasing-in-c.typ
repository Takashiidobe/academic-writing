#bibliography("aliasing-in-c.bib")

== Aliasing in C
<aliasing-in-c>
You can alias functions in C using
`__attribute__(weak, alias($new_name))` or using inline asm.

If you alias using `weak_alias` with the gcc `__attribute__`, the
original symbol ends up in the assembly, but there’s a directive that
lets you call the function with either name.

With the `__asm__` directive, the function’s name is renamed.

```c
#include <stdio.h>

#define weak_alias(old, new)                                                   \
  extern __typeof(old) new __attribute__((weak, alias(#old)))

int power2(int x) { return x * x; }
weak_alias(power2, __power2);

int power3(int x) __asm__("__power3");
int power3(int x) { return x * x * x; }

int main() {
  printf("%d\n", power2(5));
  printf("%d\n", __power2(5));
  printf("%d\n", power3(5));
}
```

The generated asm code
```sh
$ gcc -S alias.c -O0 -o-
```

```asm
    .file   "alias.c"
    .text
    .globl  power2
    .type   power2, @function
power2:
.LFB0:
    .cfi_startproc
    pushq   %rbp
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp
    .cfi_def_cfa_register 6
    movl    %edi, -4(%rbp)
    movl    -4(%rbp), %eax
    imull   %eax, %eax
    popq    %rbp
    .cfi_def_cfa 7, 8
    ret
    .cfi_endproc
.LFE0:
    .size   power2, .-power2
    .weak   __power2
    .set    __power2,power2
    .globl  __power3
    .type   __power3, @function
__power3:
.LFB1:
    .cfi_startproc
    pushq   %rbp
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp
    .cfi_def_cfa_register 6
    movl    %edi, -4(%rbp)
    movl    -4(%rbp), %eax
    imull   %eax, %eax
    imull   -4(%rbp), %eax
    popq    %rbp
    .cfi_def_cfa 7, 8
    ret
    .cfi_endproc
.LFE1:
    .size   __power3, .-__power3
    .section    .rodata
.LC0:
    .string "%d\n"
    .text
    .globl  main
    .type   main, @function
main:
.LFB2:
    .cfi_startproc
    pushq   %rbp
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp
    .cfi_def_cfa_register 6
    movl    $5, %edi
    call    power2
    movl    %eax, %esi
    movl    $.LC0, %edi
    movl    $0, %eax
    call    printf
    movl    $5, %edi
    call    __power2
    movl    %eax, %esi
    movl    $.LC0, %edi
    movl    $0, %eax
    call    printf
    movl    $5, %edi
    call    __power3
    movl    %eax, %esi
    movl    $.LC0, %edi
    movl    $0, %eax
    call    printf
    movl    $0, %eax
    popq    %rbp
    .cfi_def_cfa 7, 8
    ret
    .cfi_endproc
.LFE2:
    .size   main, .-main
    .ident  "GCC: (GNU) 14.2.1 20240801 (Red Hat 14.2.1-1)"
    .section    .note.GNU-stack,"",@progbits
```

You can combine this with elf version symbols in order to generate
functions that can change:

```c
// This is the default
__asm__(".symver power_v1, power@");
int power_v1(int x) { return x * x; }

// This is our new version, power_v2
__asm__(".symver power_v2, power@@v2");
int power_v2(int x, int power) {
  int res = 1;

  for (int i = 0; i < power; i++) {
    res *= x;
  }
  return res;
}
```

And this version code:

```vers
v1 {
  local: power_v1;
};

v2 {
  local: power_v2;
};
```

```sh
$ gcc elf-versioning.c -fPIC -shared -o elf-versioning.so -Wl,--version-script,elf-versioning.vers
```

We can check to make sure that there are indeed two versions of power:

```sh
$ readelf --dyn-syms -W elf-versioning.so | rg power
     6: 0000000000001108    53 FUNC    GLOBAL DEFAULT   13 power
     7: 00000000000010f9    15 FUNC    GLOBAL DEFAULT   13 power@@v2
```

We can then compile it into a shared library and link to it to call it.

```sh
$ gcc elf-test.c -Wl,--export-dynamic -Lelf-versioning -o elf-test
```

Some extra notes are here: @glibc2024

== Calling Older symbols in C
<calling-older-symbols-in-c>
You can also call older versions of functions using the `__asm__`
directive as well.

Say we use `nm` to find the versions of realpath we have.

```sh
$ nm -D /usr/lib64/libc.so.6 | rg "realpath@"
0000000000041a40 T realpath@@GLIBC_2.3
00000000001661d0 T realpath@GLIBC_2.2.5
```

The 2.3 version is the default, but there’s a 2.2.5 version as well. We
can explicitly use an older symbol:

```c
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

__asm__(".symver realpath, realpath@GLIBC_2.2.5");
int main() {
  const char *unresolved = "/lib64";
  char resolved[PATH_MAX + 1];

  if (!realpath(unresolved, resolved)) {
    return 1;
  }

  printf("%s\n", resolved);

  return 0;
}
```

== Writing our own libraries
<writing-our-own-libraries>
Let’s write a library that exports two functions, one that returns the
power of a number and a second version, which returns a number to a
given power. We can then export it to the same symbol. By default
callers will get `power@@v2`, but they can also call the older version
too.

```c
__asm__(".symver power_v1, power@");
int power_v1(int x) { return x * x; }

__asm__(".symver power_v2, power@@v2");
int power_v2(int x, int power) {
  int res = 1;

  for (int i = 0; i < power; i++) {
    res *= x;
  }
  return res;
}
```

We can then create our shared library:

```sh
$ gcc libpower.c -fPIC -shared -o libpower.so -Wl,--version-script,libpower.vers
```

Next, we can create a program that specifically calls the older version
of power:

```c
#include <stdio.h>

int power(int base); // calls power@ now because it's been redefined

__asm__(".symver power,power@");
int main() {
  int base = 5;
  int exp = 3;
  int result;

  // Call the older version of the power function
  result = power(base);

  printf("Result: %d\n", result);

  return 0;
}
```

And link to it:

```sh
$ gcc -o my_program my_program.c -L. -lpower
```

And run it, which returns 25 (5 \* 5), so we’ve called the older
version.

```sh
$ LD_LIBRARY_PATH=. ./my_program
Result: 25
```
