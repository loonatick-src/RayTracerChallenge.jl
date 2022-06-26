struct Canvas{F <: Number}
    width::Integer
    height::Integer
    grid::Matrix{Color{F}}

    function Canvas(w, h, ::Type{F}) where {F <: Number}
        g = zeros(Color{F}, w, h)
        new{F}(w, h, g)
    end
end

function write_pixel(c::Canvas, row, col, clr::Color)
    c.grid[row,col] = clr
end

function canvas_to_ppm(c::Canvas)
    (w, h) = (c.width, c.height)
    "P3\n$(w) $(h)\n255"
end

function canvas_to_ppm(w, h)
    "P3\n$(w) $(h)\n255"
end
