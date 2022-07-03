# TODO: let `max_val` be a global const
struct Canvas{F <: Number}
    width::Integer
    height::Integer
    grid::Matrix{Color{F}}

    function Canvas(w, h, ::Type{F}) where {F <: Number}
        # store image in row-major order
        g = zeros(Color{F}, w, h)
        # storing image in row-major order
        new{F}(w, h, g)
    end
end

function write_pixel(c::Canvas, x, y, clr)
    c.grid[x,y] = clr
end

function ppm_scale(f; max_val=255)
    convert(Int, round(clamp(f, 0, 1) * max_val))
end

function ppm_scale(c::Color; max_val=255)
    r = ppm_scale(c.r; max_val=max_val)
    g = ppm_scale(c.g; max_val=max_val)
    b = ppm_scale(c.b; max_val=max_val)
    (r, g, b)
end

function canvas_to_ppm(c::Canvas; max_val=255)
    # FIXME: this has terrible perfomance
    # Does Julia have anything similar to string streams
    # from C++?
    (w, h) = (c.width, c.height)
    ppm_string = "P3\n$(w) $(h)\n$(max_val)\n"
    # uncoalesced memory access RIP
    for img_row in eachcol(c.grid)
        for clr in img_row[1:end-1]
            (r, g, b) = ppm_scale(clr; max_val=max_val)
            ppm_string *= "$(r) $(g) $(b) "
        end
        (r, g, b) = ppm_scale(img_row[end])
        ppm_string *= "$(r) $(g) $(b)\n"
    end
    ppm_string
end

function canvas_to_ppm(w, h; max_val=255)
    "P3\n$(w) $(h)\n$(max_val)"
end

function canvas_to_ppm_matrix(c::Canvas; max_val=255)
    (m, n) = size(c.grid)
    pixel_count = m*n
    ppm_buffer = Matrix{Int}(undef, 3, pixel_count)
    for (idx, clr) in enumerate(c.grid)
        (r, g, b) = ppm_scale(clr; max_val=max_val)
        ppm_buffer[1, idx] = r
        ppm_buffer[2, idx] = g
        ppm_buffer[3, idx] = b
    end
    ppm_buffer
end

function canvas_to_ppm_matrix!(ppm_buffer::Matrix{Int}, c::Canvas; max_val=255)
    (m, n) = size(c.grid)
    (p, q) = size(ppm_buffer)
    @assert 3*m*n == p*q  # TODO: change to exception etc
    for (idx, clr) in enumerate(c.grid)
        (r, g, b) = ppm_scale(clr; max_val=max_val)
        ppm_buffer[1, idx] = r
        ppm_buffer[2, idx] = g
        ppm_buffer[3, idx] = b
    end
end