using StaticArrays
using LinearAlgebra: det

Mat4{T} = MMatrix{4, 4, T}
Mat2{T} = MMatrix{2, 2, T}

function submatrix(M, row, col)
    (m, n) = size(M)
    subM = similar(M, m-1, n-1)
    submatrix!(subM, M, row, col)
    subM
end

function submatrix!(subM, M, row, col)
    (m, n) = size(M)
    subM_1_1 = @view M[1:row-1, 1:col-1]
    subM_1_2 = @view M[1:row-1, col+1:end]
    subM_2_1 = @view M[row+1:end, 1:col-1]
    subM_2_2 = @view M[row+1:end, col+1:end]
    subM[1:row-1, 1:col-1] .= subM_1_1
    subM[1:row-1, col:end] .= subM_1_2
    subM[row:end, 1:col-1] .= subM_2_1
    subM[row:end, col:end] .= subM_2_2
end

function submatrix(M::MMatrix{m, n, T}, row, col) where {T, m, n}
    subM = MMatrix{m-1, n-1, T}(undef)
    submatrix!(subM, M, row, col)
    subM
end

function submatrix!(subM::MMatrix{ms, ns, T}, M::MMatrix{m, n, T}, row, col) where {T, ms, ns, m, n}
    subM_1_1 = @view M[1:row-1, 1:col-1]
    subM_1_2 = @view M[1:row-1, col+1:end]
    subM_2_1 = @view M[row+1:end, 1:col-1]
    subM_2_2 = @view M[row+1:end, col+1:end]
    subM[1:row-1, 1:col-1] .= subM_1_1
    subM[1:row-1, col:end] .= subM_1_2
    subM[row:end, 1:col-1] .= subM_2_1
    subM[row:end, col:end] .= subM_2_2
end

minor(M, row, col) = det(submatrix(M, row, col))

function cofactor(M, row, col)
    rv = minor(M, row, col)
    if iseven(row * col)
        rv *= -one(eltype(M))
    end
    rv
end