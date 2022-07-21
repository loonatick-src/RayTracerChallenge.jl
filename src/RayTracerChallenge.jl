module RayTracerChallenge

# TODO: consider using reexport to make this less ugly
export Vec4, Vec3, Point
export isPoint, isVec
export ×, magnitude, length_squared, normalize
export make_point, make_vec3
export write_pixel
export Color
export Canvas
export Mat4, Mat2
export canvas_to_ppm, ppm_scale
export submatrix, minor, cofactor
export canvas_to_ppm_matrix, canvas_to_ppm_matrix!
export scaling, translation
export rotation_x, rotation_y, rotation_z, shearing

include("vec.jl")
include("mat.jl")
include("color.jl")
include("canvas.jl")
include("transform.jl")
include("utils.jl")

end
