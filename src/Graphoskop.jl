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

function ge(G, o)
    t1 = time()
    a = adjacency_matrix(G,Float64)
    solver = Graphoskop.approxchol_lap(a);
    x = solver(o);
    println("Solver finished in ", (time() - t1), " seconds")
    return sqrt(dot(o, x));
end

end
