using Graphs
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

function timeDataFor20k()
    tdf = DataFrame(Time = Float64[])
    attributes = pwd() * "../test/data/reddit_11_2016_line_node_attributes.csv"
    graph = pwd() * "../test/data/reddit_11_2016_linegraph.csv"
    df = DataFrame(CSV.File(open(graph))); 
    attributes = DataFrame(CSV.File(open(attributes)));
    size = max(maximum(df.src), maximum(df.trg))
    G = SimpleGraph(size);
    for row in eachrow(df)
        add_edge!(G, row.src, row.trg);
    end
    total = 0.0
    for _ in (0,100)
        t1 = time()
        id_result = Graphoskop.ge(G, vec(Array(select(attributes, :ideology_difference => AsTable))));
        of_result = Graphoskop.ge(G, vec(Array(select(attributes, :offensiveness => AsTable))));
        t2 = time()
        total += t2 - t1
        push!(tdf,[total])
    end
    CSV.write("20k_julia_out.csv", df)
end