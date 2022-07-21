using StaticArrays
using SIMD
import LinearAlgebra: dot

# TODO: using a VecElement N-tuple in the constructor hints the compiler
# to use the vector register ABI instead of the scalar ABI
# examine `@code_native` for these constructors
Vec4{T} = Vec{4, T}
# convenience constructors
Vec4(T::Type, x, y, z, w) = Vec4{T}((x, y, z, w))
Vec4(xyzw::NTuple{4, T}) where{T} = Vec{4, T}(xyzw)

# 3-vector
Vec3(t::NTuple{3, T})  where {T} = Vec4{T}((t..., zero(T)))
Vec3(x::T, y::T, z::T) where {T} = Vec4{T}((x, y, z, zero(T)))

# point
@inline Point(t::NTuple{3, T}) where {T} = Vec4{T}((t..., one(T)))
@inline Point(x::T, y::T, z::T) where {T} = Vec4{T}((x, y, z, one(T)))

"""Cross Product"""
function ×(v₁::Vec4, v₂::Vec4)
    (x₁, y₁, z₁) = (v₁[1], v₁[2], v₁[3])
    (x₂, y₂, z₂) = (v₂[1], v₂[2], v₂[3])
    x = y₁*z₂ - z₁*y₂
    y = z₁*x₂ - x₁*z₂
    z = x₁*y₂ - y₁*x₂
    Vec3(x,y,z)
end

"""Dot Product"""
function dot(v₁::Vec4{T}, v₂::Vec4{T}) where {T}
    sum(v₁ * v₂)
end

"""length_squared"""
function length_squared(v::Vec4)
    sum(v^2)
end

"""Magnitude"""
function magnitude(v::Vec4)
    √(length_squared(v))
end

import Base.zero

function zero(::Vec4{T}) where {T}
    z = zero(T)
    Vec4{T}((z, z, z, z))
end

function isPoint(v::Vec4)
    v[4] == one(eltype(v))
end

function isVec(v::Vec4)
    v[4] == zero(eltype(v))
end

function normalize(v::Vec4)
    l2norm = magnitude(v)
    v/l2norm
end

function make_point(v::Vec4{T}) where {T}
    Point(v[1], v[2], v[3])
end

function make_vec3(v::Vec4{T}) where {T}
    Vec3(v[1], v[2], v[3])
end
