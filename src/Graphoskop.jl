"""A fork of Laplacians.jl with support for the Graphs.jl datatypes.
"""
module Graphoskop

function __init__()

    #=
    if !isdefined(Main, :GRAPHOSKOP_NOPLOT) & !haskey(ENV,"GRAPHOSKOP_NOPLOT")
        eval(Expr(:using, :PyPlot))
    end
    =#

    if isdefined(Main, :GRAPHOSKOP_AMG)
        eval(Expr(:using, :PyAMG))

    end
  end

using Laplacians
using LinearAlgebra
using Graphs
using CSV
using DataFrames
using SimpleWeightedGraphs
using Plots

function ge(G, o, verbose=false)
    a = adjacency_matrix(G,Float64)
    t1 = time()
    solver = Laplacians.approxchol_lap(a);
    x = solver(o);
    if verbose
        println("Solver finished in ", (time() - t1), " seconds")
    end
    return sqrt(dot(o, x));
end
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
    xlabel!("Total time")
    ylabel!("Iterations")
    png("time_comparison")
end

end
