using Graphs
using CSV
using DataFrames
using SimpleWeightedGraphs
using Plots
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
    CSV.write("julia_out.csv", df)
end

function plotTestData()
    julia_data = CSV.read("julia_out.csv", DataFrame)
    python_data = CSV.read("python_out.csv", DataFrame)
    Plots.plot(julia_data.Time, label="Julia")
    plot!(python_data.Time, label="Python")
    xlabel!("Iterations")
    ylabel!("Total time (in seconds)")
    png("time_comparison")
end