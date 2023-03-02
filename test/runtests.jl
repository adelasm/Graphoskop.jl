include("../src/Graphoskop.jl")

using Test
using LinearAlgebra
using SimpleWeightedGraphs
using Graphs
using CSV
using DataFrames

@testset "Graphoskop.jl" begin
    #include("testSolvers.jl")
    function ge(G, o)
        solver = Graphoskop.approxchol_lap(G);
        x = solver(o);
        return sqrt(dot(o', x));
   end
   

   attributes = "C:\\Users\\Adelas\\.julia\\dev\\NetworkAnalysis\\data\\reddit_11_2016_line_node_attributes.csv"
   graph = "C:\\Users\\Adelas\\.julia\\dev\\NetworkAnalysis\\data\\reddit_11_2016_linegraph.csv"

   df = DataFrame(CSV.File(open(graph))); 
   attributes = DataFrame(CSV.File(open(attributes)));
   size = max(maximum(df.src), maximum(df.trg))
   G = SimpleGraph(size);
   for row in eachrow(df)
    add_edge!(G, row.src, row.trg);
   end
   
   id_result = ge(G, Matrix(select(attributes, :ideology_difference => AsTable)));
   of_result = ge(G, Matrix(select(attributes, :offensiveness => AsTable)));
   @test id_result = 2.0341642960894033
   @test of_result = 3.456012563079861

end
