using Graphoskop
using Test
using LinearAlgebra
using SimpleWeightedGraphs
using Graphs
using CSV
using DataFrames
using Laplacians
using SparseArrays
using Random

@testset "ge on big data sets" begin
   attributes = pwd() * "/data/reddit_11_2016_line_node_attributes.csv"
   graph = pwd() * "/data/reddit_11_2016_linegraph.csv"

   df = DataFrame(CSV.File(open(graph))); 
   attributes = DataFrame(CSV.File(open(attributes)));
   size = max(maximum(df.src), maximum(df.trg))
   G = SimpleGraph(size);
   for row in eachrow(df)
    add_edge!(G, row.src, row.trg);
   end

   t1 = time()
   id_result = Graphoskop.ge(G, vec(Array(select(attributes, :ideology_difference => AsTable))));
   of_result = Graphoskop.ge(G, vec(Array(select(attributes, :offensiveness => AsTable))));
   println("Both solvers finished in ", (time() - t1), " seconds")
   @test round(id_result, digits = 3) == 2.034
   @test round(of_result, digits = 3) == 3.456

end

@testset "ge on smaller data sets" begin
   attributes = pwd() * "/data/small_test_node_attributes.csv"
   graph = pwd() * "/data/small_test_edges.csv" 
 
   df = DataFrame(CSV.File(open(graph))); 
   attributes = DataFrame(CSV.File(open(attributes)));
   size = max(maximum(df.src), maximum(df.trg))
   G = SimpleGraph(size);
   for row in eachrow(df)
     add_edge!(G, row.src, row.trg);
   end
 
   t1 = time()
   id_result = Graphoskop.ge(G, vec(Array(select(attributes, :ideology_difference => AsTable))));
   of_result = Graphoskop.ge(G, vec(Array(select(attributes, :offensiveness => AsTable))));
   println("Both solvers finished in ", (time() - t1), " seconds")
   @test round(id_result, digits = 3) == 0.726
   @test round(of_result, digits = 3) == 1.127
 

 end

@testset "ge on smaller random datasets" begin
   rng = MersenneTwister(34567)
   G = SimpleWeightedGraph(erdos_renyi(100, 0.5, rng=rng));
   s = rand(rng, Float64, 100);
   @test round(Graphoskop.ge(G,s), digits = 3) == 0.413
end

@testset "ge on medium random datasets" begin
   rng = MersenneTwister(1234)
   G = SimpleWeightedGraph(erdos_renyi(1000, 0.5, rng=rng));
   s = rand(rng, Float64, 1000);
   @test round(Graphoskop.ge(G,s), digits = 3) == 0.406
end

@testset "average time for 200 runs of medium random datasets less than 5 seconds" begin
   total = 0.0
   for i in 0:200
      G = SimpleWeightedGraph(erdos_renyi(1000, 0.5));
      s = rand(Float64, 1000);
      start_time = time()
      result = round(Graphoskop.ge(G,s), digits = 3)
      end_time = time()
      result_time = end_time - start_time
      total += result_time
   end
   @test total/200 < 5.0
end