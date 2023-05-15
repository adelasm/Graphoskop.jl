using Graphs
using DataFrames
using SimpleWeightedGraphs
using Graphoskop
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
    CSV.write("../../outputs/julia_out.csv", df)
end