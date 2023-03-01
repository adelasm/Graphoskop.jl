include("../src/Graphoskop.jl")

using Test
using LinearAlgebra
using SimpleWeightedGraphs
using Graphs
using CSV
using DataFrames

@testset "Graphoskop.jl" begin
    include("testSolvers.jl")
    function ge(G, o)
        solver = Graphoskop.approxchol_lap(G);
        x = solver(o);
        return sqrt(dot(o', x));
   end
   

   attributes = "C:\\Users\\Adelas\\.julia\\dev\\NetworkAnalysis\\data\\reddit_11_2016_line_node_attributes.csv"
   graph = "C:\\Users\\Adelas\\.julia\\dev\\NetworkAnalysis\\data\\reddit_11_2016_linegraph.csv"

   df = DataFrame(CSV.File(open(graph))); 
   nodes = DataFrame(CSV.File(open(attributes)));
   size = max(maximum(df.src), maximum(df.trg))
   G = SimpleGraph(size);
   for row in eachrow(df)
    add_edge!(G, row.src, row.trg);
   end
   
   result = ge(G, size);
end
