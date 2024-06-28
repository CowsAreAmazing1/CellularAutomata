using GLMakie, BenchmarkTools
set_theme!(theme_dark())

function precalcoffsets(n)
    bigarr = Vector{Int64}[]
    for i in 1:n^2
        offarr = Int64[]

        omx = i % n
        omy = (floor((i-1) / n)+1) % n

        omy > 0                && push!(offarr, i+n)
        (omx != 0 && omy != 0) && push!(offarr, i+n+1)
        omx > 0                && push!(offarr, i+1)
        (omx != 0 && omy != 1) && push!(offarr, i-n+1)
        omy != 1               && push!(offarr, i-n)
        (omx != 1 && omy != 1) && push!(offarr, i-n-1)
        omx != 1               && push!(offarr, i-1)
        (omx != 1 && omy != 0) && push!(offarr, i+n-1)

        push!(bigarr, offarr)
    end
    return bigarr
end

function count_neighbours(grid, o)
    return count(==(1), grid[oa[o]])
end

function step!(grid)
    grid[:] = reshape(map((g, n) ->
        if n < 2 (0)
        elseif n > 3 (0)
        elseif n == 3 (1)
        else (g) end,
        grid,
        map(x -> count_neighbours(grid, x), 1:length(grid))),
        n, n)
end

function step!(o::Observable)
    step!(o[])
    notify(o)
end

n = 1000
oa = precalcoffsets(n)

a = Observable(map(x -> x < 0 ? 0 : 1, randn(n, n)))
f, ax = heatmap(a, colormap = :grays, figure=(size=(600, 600),))
hidedecorations!(ax);
f

for i in 1:500
    plength = copy(a[])
    step!(a)
    if plength == a[]
        print(i)
        return
    end
    sleep(1/165)
end