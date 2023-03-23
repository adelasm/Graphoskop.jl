include("../src/Graphoskop.jl")

using Test
using LinearAlgebra
using SimpleWeightedGraphs
using Graphs
using CSV
using DataFrames
using Laplacians
using SparseArrays

@testset "Graphoskop.jl" begin
    #include("testSolvers.jl")
    function ge(G, o)
        solver = Graphoskop.approxchol_lap(G,verbose=true);
        x = solver(o);
        return sqrt(dot(o', x));
   end
   

   attributes = pwd() * "\\data\\small_test_node_attributes.csv"
   graph = pwd() * "\\data\\small_test_edges.csv"

   df = DataFrame(CSV.File(open(graph))); 
   attributes = DataFrame(CSV.File(open(attributes)));
   size = max(maximum(df.src), maximum(df.trg))
   G = SimpleGraph(size);
   for row in eachrow(df)
    add_edge!(G, row.src, row.trg);
   end

   id_result = ge(G, vec(Array(select(attributes, :ideology_difference => AsTable))));
   of_result = ge(G, vec(Array(select(attributes, :offensiveness => AsTable))));
   @test id_result == 0.6951170472250192
   @test of_result == 1.1015014759360282

end
