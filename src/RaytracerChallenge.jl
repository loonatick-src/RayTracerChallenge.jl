module RaytracerChallenge

export Vec4, Vec3, Point
export isPoint, isVec
export ×, magnitude, length_squared, normalize
export make_point, make_vec3
export write_pixel
export Color
export Canvas
export Mat4
export canvas_to_ppm, ppm_scale

include("vec.jl")
include("mat.jl")
include("color.jl")
include("canvas.jl")


end