# RaytracerChallenge
## Progress
1. [X] Tuples, Points, and Vectors
2. [X] Drawing on a canvas
3. [X] Matrices
4. [ ] Matrix Transformations (WIP)
    1. [X] Translation
    2. [X] Scaling
    3. [ ] Rotation
    4. [ ] Shearing
    5. [ ] Chaining Transformations
    6. [ ] Putting it Together
5. [ ] Ray-Sphere Intersections
6. [ ] Light and Shading
7. [ ] Making a Scene
8. [ ] Shadows
9. [ ] Planes
10. [ ] Patterns
11. [ ] Reflection and Refraction
12. [ ] Cubes
13. [ ] Cylinders
14. [ ] Groups
15. [ ] Triangles
16. [ ] Constructive Solid Geometry (CSG)
17. [ ] Next Steps
## TODO
1. [ ] Replace `MVector` with non heap-alloc'd array types. Consider
   - [ ] SVector (disadvantage: immutable, in-place modification not possible)
         Consider trying this in another source file and writing benchmarks to compare the two
   - [X] SIMD.jl vector types (`*(::SMatrix{4,4,T}, ::Vec{4, T})` needs to be implemented).
2. [ ] Create benchmarks
3. [ ] Refactor tests
4. [ ] Make README.md more presentable

## Ideas
- Implement an SoA type for storing `Vec3`s and `Point`s whose interface is similar to
AoS (e.g. a regular `Vector{Vec3}`).
- Multithreading
    - Load-balancing
- GPU acceleration
    - CUDA kernels
    - Vendor-agnostic kernels

## Choice of data type for `Vec3` and `Point`
Heap-alloc'd data types are out of the question. While I am concerned about the immutability of SVectors,
I do not know for certain if mutating them is a common case or not. If "Ray Tracing in One Weekend" is
anything to go by, it most definitely is as we compute a running average. The alternative would be the
a much more memory-heavy allocation of an array of Vectors of and subsequent reduction.

**Note to self:** When in doubt, just measure and benchmark.
