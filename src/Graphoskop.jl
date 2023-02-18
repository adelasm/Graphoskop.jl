module Graphoskop

using DataStructures
using SparseArrays
using LinearAlgebra
using Arpack
using Laplacians
using Statistics

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

export approxchol_lap, ApproxCholParams, approxchol_sddm
include("laplacian_solvers/approxCholTypes.jl")
include("laplacian_solvers/approxChol.jl")

export chol_sddm, chol_lap, lapWrapSDDM, wrapCapture
include("laplacian_solvers/solverInterface.jl")

end
