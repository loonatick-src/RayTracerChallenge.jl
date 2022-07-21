function rotation_x(r::T)::Mat4{T} where {T}
    u = one(T)
    o = zero(T)
    c = cos(r)
    s = sin(r)
    Mat4{T}(u,  o,  o,  o,
            o,  c,  s,  o,
            o, -s,  c,  o,
            o,  o,  o,  u)
end

function rotation_y(r::T)::Mat4{T} where {T}
    u = one(T)
    o = zero(T)
    c = cos(r)
    s = sin(r)
    Mat4{T}(c,  o, -s,  o,
            o,  u,  o,  o,
            s,  o,  c,  o,
            o,  o,  o,  u)
end

function rotation_z(r::T)::Mat4{T} where {T}
    u = one(T)
    o = zero(T)
    c = cos(r)
    s = sin(r)
    Mat4{T}(c,  s,  o,  o,
           -s,  c,  o,  o,
            o,  o,  u,  o,
            o,  o,  o,  u)
end
            
function shearing(xyz::NTuple{6,T})::Mat4{T} where {T}
    # TODO: consider making more generic by using UnPack.jl
    (xy, xz, yx, yz, zx, zy) = xyz
    u = one(T)
    o = zero(T)
    Mat4{T}(u,  yx, zx, o,
            xy, u,  zy, o,
            xz, yz, u,  o,
            o,  o,  o,  u)
end

function shearing(xy, xz, yx, yz, zx, zy)
    shearing((xy, xz, yx, yz, zx, zy))
 end
