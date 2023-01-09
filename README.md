![TFLS-W-trans](https://user-images.githubusercontent.com/52105833/211307736-0e5aef49-ef72-4787-a3c7-38e252750b61.png)

# TFLS.jl
A Julia script to find contours of vessels-like shapes and calculate pairwise distance between them. For example, consider the following picture: 
![img](https://user-images.githubusercontent.com/52105833/206712072-b37dfbe6-f16d-4917-9ca0-ced833c33077.png)

It has 5 contours, and I'm going to locate, highlight, and calculate the pairwise distance between them.  
To better detect the contours, First, I perform thinning on the image to locate the contours quickly, and then I locate them:
```julia
julia> contours, dists, thinned = main("img.png");

julia> contours
5-element Vector{CartesianIndex{2}}:
 CartesianIndex(386, 77)
 CartesianIndex(149, 105)
 CartesianIndex(500, 409)
 CartesianIndex(43, 528)
 CartesianIndex(257, 661)

julia> dists
5×5 Matrix{Float64}:
   0.0    238.648  351.027  566.613  598.078
 238.648    0.0    464.346  436.079  566.392
 351.027  464.346    0.0    472.239  350.076
 566.613  436.079  472.239    0.0    251.962
 598.078  566.392  350.076  251.962    0.0
```
Then I can check whether I successfully detected the contours or not:
```julia
julia> highlited = highlight_contours(thinned, contours)
```
Then if I zoom in a little bit, I can see the contours with red color:
![image](https://user-images.githubusercontent.com/52105833/206715313-9d22f4a0-9662-49ef-984e-2c9b959244c6.png)

I did this inspired by this question: [[Link](https://stackoverflow.com/q/74595135/11747148)]
