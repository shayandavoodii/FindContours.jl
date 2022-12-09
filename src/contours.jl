include("utils.jl")
using .FindContours

contours, distances, thinned = main("img/img.png")
highlight_contours(thinned, contours)
