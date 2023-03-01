include("../src/Graphoskop.jl")

using Test
using LinearAlgebra
using SimpleWeightedGraphs
using Graphs

@testset "Graphoskop.jl" begin
    include("testSolvers.jl")
    function ge(G, o)
        solver = Graphoskop.approxchol_lap(G);
        x = solver(o);
        return sqrt(dot(o', x));
   end
   
   n = 1000;
   G = adjacency_matrix(SimpleWeightedGraph(erdos_renyi(n, n * 2)));
   o = rand(Float64, n);
   result = ge(G, o);
end
