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
            make_vec3(p),
            make_vec3(v)
        )
    end
end

function tick(env, proj::Projectile{T}; dt = sqrt(eps(T))) where {T <: AbstractFloat}
    position = proj.position + proj.velocity*dt
    velocity = proj.velocity + env.gravity + env.wind*dt
    Projectile(position, velocity)
end

function simulate_projectile(p::Projectile{T}, env::Environment{T}, t; dt = sqrt(eps(T))) where {T}
    ts = 0:dt:t
    N = length(ts)
    timeseries_data = Vector{typeof(p)}(undef, N)
    for (i, _) in enumerate(ts)
        timeseries_data[i] = p
        p = tick(env, p; dt=dt)
    end
    timeseries_data
end

r₀ = Point(0.0, 0.0, 0.0)
v₀ = 2.0 * normalize(Vec3(1.0, 1.0, 0.0))
proj = Projectile(r₀, v₀)

grav = -9.8 * Vec3(0.0, 1.0, 0.0)
wind = Vec3(0.0, 0.0, 0.0)
env = Environment(grav, wind)

timeseries_data = simulate_projectile(proj, env, 0.5)