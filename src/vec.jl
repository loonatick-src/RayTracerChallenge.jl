using StaticArrays
using SIMD
import LinearAlgebra: dot

# TODO: change to non-heap-alloc'd vector type
Vec4{T} = MVector{4, T}

Vec3(t::NTuple{3, T})  where {T} = Vec4(t..., zero(T))
Vec3(x::T, y::T, z::T) where {T} = Vec4(x, y, z, zero(T))

Point(t::NTuple{3, T}) where {T} = Vec4(t..., one(T))
Point(x::T, y::T, z::T) where {T} = Vec4(x, y, z, one(T))

"""Cross Product"""
function ×(v₁::Vec4, v₂::Vec4)
    (x₁, y₁, z₁) = (v₁[1], v₁[2], v₁[3])
    (x₂, y₂, z₂) = (v₂[1], v₂[2], v₂[3])
    x = y₁*z₂ - z₁*y₂
    y = z₁*x₂ - x₁*z₂
    z = x₁*y₂ - y₁*x₂
    Vec3(x,y,z)
end

"""length_squared"""
function length_squared(v::Vec4)
    sum(v.^2)
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
