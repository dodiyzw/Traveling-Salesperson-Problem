using Graphs, SimpleWeightedGraphs
using GraphsFlows
using Plots, GraphRecipes
using CairoMakie
using CSV
using DataFrames
using Combinatorics
using LinearAlgebra
using DataStructures

struct path_cost
    cost::Float64
    path::Vector{Int64}
end

function count_cost(mat, path_ls)
    cost = 0
    for ii = 1:length(path_ls)-1
        cost += mat[path_ls[ii], path_ls[ii+1]]
    end
    return path_cost(cost, path_ls)
end


function get_shortest(mat, path_ls)
    cost_array = collect([count_cost(mat, l_) for l_ in path_ls])
    min_time = minimum([x.cost for x in cost_array])
    solution = [x for x in cost_array if x.cost == min_time]
    if length(solution) == 1
        return solution[1]
    else
        println("There multiple path with shortest time")
        return solution
    end
end

coordinates = OrderedDict(
    "YNC" => "1.3071245199420003, 103.77167655144235",
    "Haw Par" => "1.2830384265858783, 103.78217299746967",
    "GBTB" => "1.2819276177110668, 103.86361319700919",
    "Orchard" => "1.3049813898567282, 103.83220912630519",
    "Chinatown" => "1.2847345218546116, 103.84356999746966",
    "Clarke Quay" => "1.2883322170514238, 103.84668776863414",
    "Jewel" => "1.3603852042025135, 103.9897914735741",
)


file = "data.csv"
df = CSV.read(file, DataFrame)
mat = Matrix(df)
locations = mat[1:end, 1]
weights = mat[1:end, 2:end]
weights = convert(Matrix{Float64}, weights)

#Visualizing the initial graph
begin
    g = SimpleDiGraph(weights)
    all_ = graphplot(g, curves = false, names = locations, axis_buffer = 0.12)
    savefig(all_, "Plots/all.png")
end


#TSP implementation 

#Permutation of all possible paths
begin
    ls = collect(permutations(2:size(weights)[1]))
    push!.(ls, 1)
    pushfirst!.(ls, 1)
end



shortest = get_shortest(weights, ls)



begin
    labels = [locations[i] for i in shortest.path]
    xy = [coordinates[label] for label in labels]
    k = [split.(c, ",") for c in xy]
    kk = [strip.(s) for s in k]
    qq = [parse.(Float64, s) for s in kk]
    ys = [qq[i][1] for i = 1:length(qq)]
    xs = [qq[i][2] for i = 1:length(qq)]
end

###Plotting 
begin
    x_min = minimum(xs)
    x_max = maximum(xs)
    p = Plots.plot(axis = ([], false), legend = false, xlims = (x_min-0.03, x_max+0.03))

    for ii = 1:length(xs)-1
        Plots.plot!(
            [xs[ii:ii+1]],
            [ys[ii:ii+1]],
            marker = :circle,
            markercolor = :red,
            markersize = 5,
            arrow = (:closed, 10.5, :blue),
            arrowsize = 10,
            linewidth = 2,
            linecolor = :green,
        )
        #Plots.annotate!(xs[ii]+0.019, ys[ii]+0.002, ("$(labels[ii])", 9, :black, :topright))
    end
    #Manual control for positioning of annotation
    Plots.annotate!(xs[1]-0.02, ys[1], ("$(labels[1])", 9, :black, :topright))
    Plots.annotate!(xs[2]+0.02, ys[2], ("$(labels[2])", 9, :black, :topright))
    Plots.annotate!(xs[3]+0.02, ys[3], ("$(labels[3])", 9, :black, :topright))
    Plots.annotate!(xs[4]+0.02, ys[4], ("$(labels[4])", 9, :black, :topright))
    Plots.annotate!(xs[5]+0.02, ys[5], ("$(labels[5])", 9, :black, :topright))
    Plots.annotate!(xs[6]-0.023, ys[6], ("$(labels[6])", 9, :black, :topright))
    Plots.annotate!(xs[7]-0.02, ys[7], ("$(labels[7])", 9, :black, :topright))
    Plots.annotate!((xs[1]+xs[2])/2, (ys[1]+ys[2]+0.01)/2, (string(weights[1,7]), 9))
    Plots.annotate!((xs[2]+xs[3]+0.02)/2, (ys[2]+ys[3]-0.01)/2, (string(weights[7,4]), 9))
    Plots.annotate!((xs[3]+xs[4]+0.02)/2, (ys[3]+ys[4]+0.01)/2, (string(weights[4,3]), 9))
    Plots.annotate!((xs[4]+xs[5])/2, (ys[4]+ys[5]-0.01)/2, (string(weights[3,5]), 9))
    Plots.annotate!((xs[5]+xs[6])/2, (ys[5]+ys[6]+0.01)/2, (string(weights[5,6]), 9))
    Plots.annotate!((xs[6]+xs[7]-0.02)/2, (ys[6]+ys[7]-0.01)/2, (string(weights[6,2]), 9))
    Plots.annotate!((xs[7]+xs[1]-0.02)/2, (ys[7]+ys[1]-0.01)/2, (string(weights[2,1]), 9))
    Plots.annotate!(xs[1]-0.015, ys[1]-0.005, ("(start/end)", 9, :black, :topright))
    savefig(p, "Plots/final_path.png")
end


