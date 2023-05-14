using CSV
using DataFrames
using Plots
function plot20kTestData()
    julia_data = CSV.read("20k_julia_out.csv", DataFrame)
    python_data = CSV.read("20k_python_out.csv", DataFrame)
    Plots.plot(julia_data.Time, label="Julia")
    plot!(python_data.Time, label="Python")
    xlabel!("Iterations")
    ylabel!("Total time (in seconds)")
    png("time_comparison")
end