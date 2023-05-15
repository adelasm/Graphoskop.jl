using Graphs
using Plots
using Graphoskop

function plotTestData()
    julia_data = CSV.read("../../outputs/julia_out.csv", DataFrame)
    python_data = CSV.read("../../outputs/python_out.csv", DataFrame)
    Plots.plot(julia_data.Time, label="Julia")
    plot!(python_data.Time, label="Python")
    xlabel!("Iterations")
    ylabel!("Total time (in seconds)")
    png("time_comparison")
end