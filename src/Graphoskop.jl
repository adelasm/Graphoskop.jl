module Graphoskop

using DataStructures
using SparseArrays
using LinearAlgebra

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

include("laplacian_solvers/approxCholTypes.jl")
include("laplacian_solvers/approxChol.jl")
export approxchol_lap, ApproxCholParams, approxchol_sddm

include("laplacian_solvers/solverInterface.jl")
export chol_sddm, chol_lap, lapWrapSDDM, wrapCapture

end
