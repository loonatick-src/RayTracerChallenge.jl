# RaytracerChallenge
## TODO
1. Open issue on github.com/eschnett/SIMD.jl
2. Replace `MVector`, with non heap-alloc'd array types. Consider
   - SVector (disadvantage: immutable, in-place modification not possible)
   - SIMD.jl vector types (Small issue with SIMD.jl vectors, -0.0 != 0.0)
3. Create benchmarks
4. Refactor tests
5. Make README.md more presentable

## Ideas
Implement an SoA type for storing `Vec3`s and `Point`s whose interface is similar to
AoS (e.g. a regular `Vector{Vec3}`).

## Choice of data type for `Vec3` and `Point`
Heap-alloc'd data types are out of the question. While I am concerned about the immutability of SVectors,
I do not know for certain if mutating them is a common case or not. If "Ray Tracing in One Weekend" is
anything to go by, it most definitely is as we compute a running average. The alternative would be the
a much more memory-heavy allocation of an array of Vectors of and subsequent reduction.

So, I could use the SIMD vectors for the time being. It's not as if the -0.0 != 0.0 is going to break the
arithmetic side of things. Hopefully.
