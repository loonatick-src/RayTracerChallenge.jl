using Revise

using RayTracerChallenge
using Test
using LinearAlgebra: dot, det, inv
using StaticArrays
using SIMD

# TODO: refactor tests into different source files

@testset "RaytracerChallenge.jl" begin
    # Write your tests here.
    atol = √(eps(Float64))
    (x, y, z, w) = (4.3, -4.1, 3.1, 2.8)
    v = Vec3(x, y, z)
    p = Point(x, y, z)
    t = Vec4((x, y, z, w))

    @testset "Vec4 Basics" begin
        @test t[1] == x
        @test t[2] == y
        @test t[3] == z
        @test t[4] == w
        @test_throws BoundsError (t[5] == x)
    end

    @testset "Vec3 Basics" begin
        @test v[1] == x
        @test v[2] == y
        @test v[3] == z
        @test isVec(v)
    end

    @testset "Point basics" begin
        @test p[1] == x
        @test p[2] == y
        @test p[3] == z
        @test isPoint(p)
    end

    v₁ = Vec3(3, -2, 5)
    v₂ = Vec3(-2, 3, 1)
    p₁ = Point(-2, 3, 1)
    @testset "Vector arithmetic" begin
        @test all(v₁ + v₂ == Vec3(
                            v₁[1] + v₂[1],
                            v₁[2] + v₂[2],
                            v₁[3] + v₂[3]))
        @test all(v₁ - v₂ == Vec3(
                            v₁[1] - v₂[1],
                            v₁[2] - v₂[2],
                            v₁[3] - v₂[3]))
    end

    @testset "Vector-Point arithmetic" begin
        @test all(p₁ + v₁ == Point(
                            v₁[1] + p₁[1],
                            v₁[2] + p₁[2],
                            v₁[3] + p₁[3]))
        
        @test all(p₁ - v₁ == Point(
                            p₁[1] - v₁[1],
                            p₁[2] - v₁[2],
                            p₁[3] - v₁[3]))

        @test isPoint(p₁ - v₁)
        @test isPoint(p₁ + v₁)
    end

    @testset "Negation" begin
        @test 0.0 == -0.0
        @test all(-v == Vec3(-x, -y, -z))
        @test all(-v - Vec3(-x, -y, -z) == zero(v))
        @test all(zero(typeof(v)) - v == Vec3(-x, -y, -z))
    end

    # turns out π is an irrational number
    # who knew
    approx_π = convert(Float64, π)
    @testset "scalar multiplication" begin
        @test all(2v == Vec3(2x, 2y, 2z))
        @test all(v/2 == Vec3(x/2, y/2, z/2))
        @test all(v*2 == Vec3(2x, 2y, 2z))
        @test all(approx_π*v == Vec3(approx_π*x, approx_π*y, approx_π*z))
    end

    @testset "Vector magnitude" begin
        @test magnitude(v) == √(x*x + y*y + z*z)
        @test magnitude(Vec3(1.0,0.0,0.0)) == 1.0
        @test length_squared(v) == x*x + y*y + z*z
        @test length_squared(Vec3((1.0, 0.0, 0.0))) == 1.0
        @test magnitude(Vec3(1.0, 2.0, 3.0)) == √(14.0)
        @test magnitude(Vec3(-1.0, -2.0, -3.0)) == √(14.0)
    end

    @testset "Normalisation" begin
        v = Vec3(4.0, 0.0, 0.0)
        @test all(normalize(v) == Vec3(1.0, 0.0, 0.0))
        v = Vec3(1.0, 2.0, 3.0)
        l2norm = √(1.0^2 + 2.0^2 + 3.0^2)
        @test all(normalize(v) == Vec3(1/l2norm, 2/l2norm, 3/l2norm))
    end

    v₁ = Vec3(1, 2, 3)
    v₂ = Vec3(2, 3, 4)
    @testset "Dot product" begin
        @test dot(v₁, v₂) == 1*2 + 2*3 + 3*4
    end

    @testset "Cross Product" begin
        @test all(v₁ × v₂ == Vec3(-1, 2, -1))
        @test all(v₂ × v₁ == Vec3(1, -2, 1))
        @test all(v₁ × v₁ == Vec3(0, 0, 0))
    end

    m = Mat4(
        [
            1    2    3    4;
            5.5  6.5  7.5  8.5;
            9    10   11   12;
            13.5 14.5 15.5 16.5
        ]
    )
    @testset "Matrix basics" begin
        @test m[1,1] == 1
        # TODO        
    end

    (r, g, b) = (-0.5, 0.4, 1.7)
    c = Color(r, g, b)
    @testset "Color basics" begin
        @test c.r == r
        @test c.g == g
        @test c.b == b
    end

    (r₁, g₁, b₁) = (1.0, 0.6, 0.75)
    (r₂, g₂, b₂) = (0.8, 0.1, 0.25)
    c₁ = Color(r₁, g₁, b₁)
    c₂ = Color(r₂, g₂, b₂)
    @testset  "Color operations" begin
        @test c₁ + c₂ == Color(r₁ + r₂, g₁ + g₂, b₁ + b₂)
        @test c₁ - c₂ == Color(r₁ - r₂, g₁ - g₂, b₁ - b₂)
        @test c * 2 == Color(-1.0, 0.8, 3.4)
        @test c₁ * c₂ == Color(r₁ * r₂, g₁ * g₂, b₁ * b₂)
    end

    @testset "Canvas tests" begin
        Ftype = Float16
        cnvs = Canvas(10, 20, Ftype)
        @testset "Canvas constructors" begin
            @test cnvs.width == 10
            @test cnvs.height == 20
            @testset "Canvas constructor grid" begin
                z = zero(eltype(cnvs.grid))
                for c in cnvs.grid
                    @test c == z
                end
            end
        end

        @testset "Canvas editing" begin
            red = Color{Ftype}(1, 0, 0)
            write_pixel(cnvs, 2, 3, red)
            @test cnvs.grid[2,3] == red
        end

        @testset "Canvas to PPM" begin
            c = Canvas(5, 3, Float16)
            ppm = canvas_to_ppm(5, 3)
            @test ppm == "P3
5 3
255"
        end

        @testset "PPM Pixel data" begin
            # construct canvas
            Ftype = Float16
            c = Canvas(5, 3, Ftype)
            # 3 rows, 5 columns
            @test size(c.grid) == (5, 3)
            # construct colors for writing to canvas
            c₁ = Color{Ftype}(1.5, 0, 0)
            c₂ = Color{Ftype}(0, 0.5, 0)
            c₃ = Color{Ftype}(-0.5, 0, 1)
            # write colors to canvas
            write_pixel(c, 1, 1, c₁)
            write_pixel(c, 3, 2, c₂)
            write_pixel(c, 5, 3, c₃)
            # format to PPM
            ppm = canvas_to_ppm(c)
            # split by newlines
            ppm_lines = split(ppm, '\n')
            expected_lines = [
                "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
                "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0",
                "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255"
            ]
            for (line, exp_line) in zip(ppm_lines[4:6], expected_lines)
                @test line == exp_line
            end

            ppm_matrix = canvas_to_ppm_matrix(c)
            expected_values = [ 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                                0 0 0 0 0 0 0 128 0 0 0 0 0 0 0;
                                0 0 0 0 0 0 0 0 0 0 0 0 0 0 255]

            # let's start by comparing sizes
            (mₑ, nₑ) = size(expected_values)
            (m, n) = size(c.grid)
            @test 3 * m * n == mₑ * nₑ

            for (clr_ppm, clr_exp) in zip(ppm_matrix, expected_values)
                @test clr_ppm == clr_exp
            end
        end
    end

    @testset "Matrix tests" begin
        @testset "Submatrix" begin
            A = @MMatrix [ 1  5  0;
                          -3  2  7;
                           0  6 -3]
            @test submatrix(A, 1, 3) == @MMatrix [-3 2; 0 6]

            A = Mat4{Int64}([-6 1 1 6;
                              -8 5 8 6;
                              -1 0 8 2;
                              -7 1 -1 1])
            @test submatrix(A, 3, 2) == [-6 1 6; -8 8 6; -7 -1 1]
        end

        @testset "Minors and cofactors" begin
            A = [3 5 0; 2 -1 7; 6 -1 5]
            @test minor(A, 2, 1) == 25.0
            @test cofactor(A, 2, 1) == -25.0
        end
    end

    @testset "Affine (?) transformations" begin
        transform = translation(5.0, -3.0, 2.0)
        @test transform == [1 0 0 5;
                             0 1 0 -3;
                             0 0 1 2;
                             0 0 0 1]
        p = Point(-3.0, 4.0, 5.0)
        @testset "Multiplyting by translation matrices" begin
            transformed_p = transform * p
            @test all(transform * p == Point(2.0, 1.0, 7.0))
            inverse_transform = inv(transform)
            @test all(inverse_transform * transformed_p == p)
        end

        v = Vec3(-3.0, 4.0, 5.0)
        @testset "Translation does not affect vectors" begin
            @test all(transform * v == v)
        end

        transform = scaling(2.0, 3.0, 4.0)
        @testset "Scaling matrix applied to a point" begin
            p = Point(-4.0, 6.0, 8.0)
            @test all(transform * p == Point(-8.0, 18.0, 32.0))
        end

        @testset "Scaling matrix applied to a vector" begin
            v = Vec3(-4.0, 6.0, 8.0)
            @test all(transform * v == Vec3(-8.0, 18.0, 32.0))
        end
    end

    @testset "Rotations" begin
        p = Point(0.0, 1.0, 0.0)
        half_quarter = rotation_x(π/4)
        full_quarter = rotation_x(π/2)

        @testset "Rotate a point about x-axis" begin
            @test all( half_quarter * p ≈ Point(0.0, √(2)/2, √(2)/2) )
            @test all( full_quarter * p ≈ Point(0.0, 0.0   , 1.0   ) )
        end

        inverse_x_rot = inv(half_quarter)
        @testset "Inverse of an x-rotation rotates in the opposite direction" begin
            @test all(inverse_x_rot * p ≈ Point(0.0, √(2)/2, -√(2)/2))
        end

        p = Point(0.0, 0.0, 1.0)
        half_quarter = rotation_y(π/4)
        full_quarter = rotation_y(π/2)
        @testset "Rotations about the y-axis" begin
            @test all(half_quarter * p ≈ Point(√(2)/2, 0.0, √(2)/2))
            @test all(full_quarter * p ≈ Point(1.0, 0.0, 0.0))
        end

        p = Point(0.0, 1.0, 0.0)
        half_quarter = rotation_z(π/4)
        full_quarter = rotation_z(π/2)
        @testset "Rotations about the z-axis" begin
            @test all( half_quarter * p ≈ Point(-√(2)/2, √(2)/2, 0.0) )
            @test all( full_quarter * p ≈ Point(-1.0, 0.0, 0.0) )
        end

        p = Point(2.0, 3.0, 4.0)
        o = zero(Float64)
        transform = shearing(1.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        @testset "Shearing" begin
            @test all( transform * p ≈ Point(5.0, 3.0, 4.0) )
        end
    end
end
