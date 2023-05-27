"""A fork of Laplacians.jl with support for the Graphs.jl datatypes.
"""
module Graphoskop

using Laplacians
using LinearAlgebra
using Graphs
using SimpleWeightedGraphs

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

    function approxChol_ge(G, o, verbose=false)
        a = adjacency_matrix(G,Float64)
        t1 = time()
        solver = Laplacians.approxchol_lap(a);
        x = solver(o);
        if verbose
            println("Solver finished in ", (time() - t1), " seconds")
        end
        return sqrt(dot(o, x));
    end

    function cg_ge(G, o, verbose=false) 
        a = adjacency_matrix(G,Float64)
        t1 = time()
        solver = Laplacians.cgSolver(a);
        x = solver(o);
        if verbose
            println("Solver finished in ", (time() - t1), " seconds")
        end
        return sqrt(dot(o, x));
    end

end
