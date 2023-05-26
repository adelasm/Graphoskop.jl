using Graphs
using DataFrames
using SimpleWeightedGraphs
using Graphoskop
using CSV
function generateTestData(itera)
    df = DataFrame(Time = Float64[])
    total = 0.0
    for _ in 0:itera
        G = SimpleWeightedGraph(erdos_renyi(1000, 0.5));
        s = rand(Float64, 1000);
        start_time = time()
        round(Graphoskop.ge(G,s), digits = 3)
        end_time = time()
        result_time = end_time - start_time
        total += result_time
        push!(df, [total])
    end
    CSV.write("/outputs/julia_out.csv", df)
end


function generateRandomTestData(size)
    G = SimpleWeightedDiGraph(erdos_renyi(size, 0.5))
    graph = DataFrame(src=Int64[], trg=Int64[])
    attributes = DataFrame(index=Int64[], weight=Float64[])
    for vertex in vertices(G)
        push!(attributes, [getindex(vertex) rand()])
    end
    for edge in edges(G)
        push!(graph, [src(edge) dst(edge)])
    end
    CSV.write(string(pwd(), "/test/data/random_", size, "_graph.csv"), graph)
    CSV.write(string(pwd(), "/test/data/random_", size, "_attributes.csv"), attributes)
end