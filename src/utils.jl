module FindContours

using Images, FileIO, ImageBinarization, Distances
export main, highlight_contours

"""
    check_adjacent(loc::CartesianIndex{2}, all_locs::Vector{CartesianIndex{2}})

Return the number of adjacent locations that are in `all_locs` to `loc`.
This function is used to determine whether a location is a corner (contour) or not.

# Arguments
- `loc::CartesianIndex{2}`: the location to check.
- `all_locs::Vector{CartesianIndex{2}}`: all the locations that aren't black.

# Returns
- `Int`: the number of adjacent locations that are in `all_locs` to `loc`.
"""
function check_adjacent(loc::T, all_locs::Vector{T}) where T<:CartesianIndex{2}
    conditions = [
        loc - CartesianIndex(0,1) ∈ all_locs,
        loc + CartesianIndex(0,1) ∈ all_locs,
        loc - CartesianIndex(1,0) ∈ all_locs,
        loc + CartesianIndex(1,0) ∈ all_locs,
        loc - CartesianIndex(1,1) ∈ all_locs,
        loc + CartesianIndex(1,1) ∈ all_locs,
        loc - CartesianIndex(1,-1) ∈ all_locs,
        loc + CartesianIndex(1,-1) ∈ all_locs
    ]

    return sum(conditions)
end

"""
    get_contours(img::BitMatrix)

Return the contours of the image `img`.

# Arguments
- `img::BitMatrix`: the image to get the contours of.

# Returns
- `Vector{CartesianIndex{2}}`: the contours of the image `img`.

"""
function find_the_contour(img::BitMatrix)
    img_matrix = convert(Array{Float64}, img)
    not_black = findall(!=(0.0), img_matrix)
    contours = Vector{CartesianIndex{2}}()
    for nb∈not_black
        t = check_adjacent(nb, not_black)
        t==1 && push!(contours, nb)
    end
    return contours
end

"""
    distance_between_contours(all_contours::Vector{CartesianIndex{2}})

Return the euclidean distance between each pair of contours in `all_contours`.

# Arguments
- `all_contours::Vector{CartesianIndex{2}}`: the contours to calculate the distance between.

# Returns
- `Matrix{Float64}`: the euclidean distance between each pair of contours in `all_contours`.
"""
function distance_between_contours(all_contours::Vector{CartesianIndex{2}})
    alltuples = Tuple.(all_contours)
    distances = pairwise(Euclidean(), alltuples)

    return distances
end

"""
    highlight_contours(img, contours)

Return the image `img` with the contours `contours` highlighted with red color.

# Arguments
- `img::BitMatrix`: the image to highlight the contours on.
- `contours::Vector{CartesianIndex{2}}`: the contours to highlight.
- `resize`::Bool=false: whether to resize the image to 512x512 or not.
- `scale`::Union{Int64, Nothing}=1: the scale to resize the image to.

# Returns
- `img_matrix`: the image `img` with the contours `contours` highlighted with red color.
"""
function highlight_contours(img, contours; resize::Bool=false, scale::Union{Int64, Float64}=1)
    img_matrix = convert(Array{RGB, 2}, img)
    foreach(c->img_matrix[c] = RGB(1.0, 0.0, 0.0), contours)
    if resize
        img_matrix = typeof(scale)==Int64 ? imresize(img_matrix, size(img).*scale) : imresize(img_matrix, ratio=scale)
    end
    return img_matrix
end

function main(img_path::String)
    img = load(img_path)
    gimg = Gray.(img)
    bin = binarize(gimg, UnimodalRosin()) .> 0.5
    thinned = thinning(bin, algo=GuoAlgo())
    contours = find_the_contour(thinned)
    dists = distance_between_contours(contours)

    return contours, dists, thinned
end
end # module
