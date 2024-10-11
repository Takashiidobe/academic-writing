---
title: "Saving Energy with SIMD instructions"
bibliography: "src/simd-energy-expenditure.bib"
---

Vectorization makes code faster. Instead of doing one operation to many
registers, you can do the same operation in tandem to 8 or 16 or 32
things at a time. We know vectorization is faster (much faster for CPU
intensive tasks, like working on matrices) but how much more energy
efficient is it?

@lemire2024; benchmarked this exact question by summing up the floats in
a 500MB array:

The naive version:

```c
float sum(float *data, size_t N) {
  double counter = 0;
  for (size_t i = 0; i < N; i++) {
    counter += data[i];
  }
  return counter;
}
```

The SIMD version:

```c
float sum(float *data, size_t N) {
  __m512d counter = _mm512_setzero_pd();
  for (size_t i = 0; i < N; i += 16) {
    __m512 v = _mm512_loadu_ps((__m512 *)&data[i]);
    __m512d part1 = _mm512_cvtps_pd(_mm512_extractf32x8_ps(v, 0));
    __m512d part2 = _mm512_cvtps_pd(_mm512_extractf32x8_ps(v, 1));
    counter = _mm512_add_pd(counter, part1);
    counter = _mm512_add_pd(counter, part2);
  }
  double sum = _mm512_reduce_add_pd(counter);
  for (size_t i = N / 16 * 16; i < N; i++) {
    sum += data[i];
  }
  return sum;
}
```

With these results:

| code routine | Power (muJ/s) | Energy per value (muJ/value) |
|--------------|---------------|------------------------------|
| naive code   | 0.055 muJ/s   | 0.11 muJ/value               |
| AVX-512      | 0.061 muJ/s   | 0.032 muJ/value              |

So the AVX-512 used 3.5 times less energy, and each op consumed 10% more
energy per unit of time, so vectorization is a win in both energy
efficiency and performance.
