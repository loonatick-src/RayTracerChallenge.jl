"""
Yes, I know Images.jl has a whole bunch of color types,
but Jamis says that we should not prematurely limit the
numerical values in [0,1]. Let's roll with this for now.
"""
struct Color{T <: AbstractFloat}
    r::T
    g::T
    b::T
end

# TODO: syntax for multiple imports from Base in one line?
import Base: +
import Base: -
import Base: *

+(c₁::Color, c₂::Color) = Color(c₁.r + c₂.r,
                                c₁.g + c₂.g,
                                c₁.b + c₂.b)

-(c₁::Color, c₂::Color) = Color(c₁.r - c₂.r,
                                c₁.g - c₂.g,
                                c₁.b - c₂.b)

*(c::Color, α::Number) = Color(α * c.r, α * c.g, α * c.b)

*(α::Number, c::Color) = c * α

*(c₁::Color, c₂::Color) = Color(c₁.r * c₂.r,
                                c₁.g * c₂.g,
                                c₁.b * c₂.b)

import Base: zero

# kinda ugly perhaps. I hope the compiler cleans it up
zero(c::Color{T}) where {T} = begin
    z = zero(T)
    Color(z, z, z)
end

function zero(::Type{Color{T}}) where {T}
    z = zero(T)
    Color(z, z, z)
end