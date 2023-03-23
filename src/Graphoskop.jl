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

using DataStructures
using SparseArrays
using LinearAlgebra
using Arpack
using Statistics

export pcg
include("graph/pcg.jl")

export approxchol_lap, ApproxCholParams, approxchol_sddm
include("laplacian_solvers/approxCholTypes.jl")
include("laplacian_solvers/approxChol.jl")

export components, vecToComps
include("graph/graphAlgs.jl")

export lap
include("graph/graphOps.jl")

export flipIndex
include("graph/graphUtils.jl")

export chol_sddm, chol_lap, lapWrapSDDM, wrapCapture
include("laplacian_solvers/solverInterface.jl")

end
