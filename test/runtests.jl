using Graphoskop
using Test
using LinearAlgebra
using SimpleWeightedGraphs
using Graphs
using CSV
using DataFrames
using Laplacians
using SparseArrays

@testset "ge on big data sets" begin
   attributes = pwd() * "\\data\\reddit_11_2016_line_node_attributes.csv"
   graph = pwd() * "\\data\\reddit_11_2016_linegraph.csv"

   df = DataFrame(CSV.File(open(graph))); 
   attributes = DataFrame(CSV.File(open(attributes)));
   size = max(maximum(df.src), maximum(df.trg))
   G = SimpleGraph(size);
   for row in eachrow(df)
    add_edge!(G, row.src, row.trg);
   end

   id_result = Graphoskop.ge(G, vec(Array(select(attributes, :ideology_difference => AsTable))));
   of_result = Graphoskop.ge(G, vec(Array(select(attributes, :offensiveness => AsTable))));
   @test round(id_result,digits=3) == 2.034
   @test round(of_result,digits=3) == 3.456

end

@testset "ge on smaller data sets" begin
    attributes = pwd() * "\\data\\small_test_node_attributes.csv"
    graph = pwd() * "\\data\\small_test_edges.csv" 
 
    df = DataFrame(CSV.File(open(graph))); 
    attributes = DataFrame(CSV.File(open(attributes)));
    size = max(maximum(df.src), maximum(df.trg))
    G = SimpleGraph(size);
    for row in eachrow(df)
     add_edge!(G, row.src, row.trg);
    end
 
    id_result = Graphoskop.ge(G, vec(Array(select(attributes, :ideology_difference => AsTable))));
    of_result = Graphoskop.ge(G, vec(Array(select(attributes, :offensiveness => AsTable))));
    @test round(id_result,digits=3) == 0.726
    @test round(of_result,digits=3) == 1.127
 

 end
