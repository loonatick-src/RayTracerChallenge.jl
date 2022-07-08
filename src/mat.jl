using StaticArrays
using LinearAlgebra: det

Mat4{T} = SMatrix{4, 4, T}
Mat2{T} = SMatrix{2, 2, T}

function submatrix(M, row, col)
    (m, n) = size(M)
    subM = similar(M, m-1, n-1)
    submatrix!(subM, M, row, col)
    subM
end

function submatrix!(subM, M, row, col)
    subM_1_1 = @view M[1:row-1, 1:col-1]
    subM_1_2 = @view M[1:row-1, col+1:end]
    subM_2_1 = @view M[row+1:end, 1:col-1]
    subM_2_2 = @view M[row+1:end, col+1:end]
    subM[1:row-1, 1:col-1] .= subM_1_1
    subM[1:row-1, col:end] .= subM_1_2
    subM[row:end, 1:col-1] .= subM_2_1
    subM[row:end, col:end] .= subM_2_2
end

function submatrix(M::MT, row, col) where {MT <: AbstractMatrix}
    (m, n) = size(M)
    # MB: similar(M::SMatrix) returns a heap-alloc'd MMatrix
    # TODO: consider specialising for SMatrix
    subM = similar(M, m-1, n-1)
    submatrix!(subM, M, row, col)
    subM
end

minor(M, row, col) = det(submatrix(M, row, col))

function cofactor(M, row, col)
    rv = minor(M, row, col)
    if iseven(row * col)
        rv *= -one(eltype(M))
    end
    rv
end

function translation(x::T, y::T, z::T) where {T}
    u = one(T)
    o = zero(T)
    # column-major order
    transform = Mat4{T}(u, o, o, o,
                        o, u, o, o,
                        o, o, u, o,
                        x, y, z, u)
    transform
end

function translation!(transform::Mat4{T}, x::T, y::T, z::T) where {T}
    u = one(T)
    o = zero(T)
    transform[1:end, 1] .= @SVector [u, o, o, o]
    transform[1:end, 2] .= @SVector [o, u, o, o]
    transform[1:end, 3] .= @SVector [o, o, u, o]
    transform[1:end, 4] .= @SVector [x, y, z, u]
end

function scaling(x::T, y::T, z::T) where {T}
    o = zero(T)
    u = one(T)    
    Mat4{T}(x, o, o, o,
            o, y, o, o,
            o, o, z, o,
            o, o, o, u)
end

function scaling!(transform::Mat4{T}, x::T, y::T, z::T) where {T}
    o = zero(T)
    u = one(T)    
    transform[1:end, 1] .= @SVector [x, o, o, o]
    transform[1:end, 2] .= @SVector [o, y, o, o]
    transform[1:end, 3] .= @SVector [o, o, z, o]
    transform[1:end, 4] .= @SVector [o, o, o, u]
end
        