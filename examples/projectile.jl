using RaytracerChallenge

struct Projectile{T}
    position::Vec4{T}
    velocity::Vec4{T}

    function Projectile(p::Vec4{T}, v::Vec4{T}) where {T}
        new{T}(
            make_point(p),
            make_vec3(v)
        )
    end
end

struct Environment{T}
    gravity::Vec4{T}
    wind::Vec4{T}

    function Environment(g::Vec4{T}, w::Vec4{T}) where {T}
        new{T}(
            make_vec3(g),
            make_vec3(w)
        )
    end
end

function tick(env, proj::Projectile{T}) where {T <: AbstractFloat}
    position = proj.position + proj.velocity
    velocity = proj.velocity + env.gravity + env.wind
    Projectile(position, velocity)
end

function simulate_projectile(p::Projectile{T}, env::Environment{T}, t; N = 100) where {T}
    timeseries_data = Vector{typeof(p)}(undef, N)
    for i in 1:N
        timeseries_data[i] = p
        p = tick(env, p)
    end
    timeseries_data
end

function ℜ²_coordinates_to_grid(pos, cnvs, x_max, y_max)
    fx = pos[1] / x_max
    fy = pos[2] / y_max
    idxx = convert(Int, round(fx * cnvs.width))
    idxy = convert(Int, round((1 - fy) * cnvs.height))
    return (idxx, idxy)
end

begin
    r₀ = Point(0.0, 1.0, 0.0)
    v₀ = 2.0 * normalize(Vec3(1.0, 1.8, 0.0)) * 11.25
    proj = Projectile(r₀, v₀)

    grav = Vec3(0.0, -1.0, 0.0)
    wind = Vec3(-0.01, 0.0, 0.0)
    env = Environment(grav, wind)

    timeseries_data = simulate_projectile(proj, env, 0.5; N=100)
    position_data = map(x->x.position, timeseries_data)
    x_max = 1.2 * maximum(map(x->x[1], position_data))
    y_max = 1.2 * maximum(map(x->x[2], position_data))
    cnvs = Canvas(900, 550, Float32)
    grid_idxs = [ℜ²_coordinates_to_grid(pos, cnvs, x_max, y_max) for pos in position_data]
    projectile_color = Color{Float32}(1.0, 0.0, 0.0)
    for (i,j) in grid_idxs
        if (1 <= i <= cnvs.width) && (0 <= j <= cnvs.height)
            write_pixel(cnvs, i, j, projectile_color)
        end
    end

    ppm_out = canvas_to_ppm(cnvs)

    open("image.ppm", "w") do io
        write(io, ppm_out)
    end
end