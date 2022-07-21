import Base: isapprox
using Base: rtoldefault

function isapprox(v::Vec4{T1}, u::Vec4{T2};
                  atol::Real=√(eps(promote_type(T1, T2)))) where {T1, T2}
    x = isapprox(v[1], u[1], atol=atol)
    y = isapprox(v[2], u[2], atol=atol)
    z = isapprox(v[3], u[3], atol=atol)
    w = isapprox(v[4], u[4], atol=atol)
    Vec4((x, y, z, w))
end
