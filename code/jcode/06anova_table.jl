## --- Set path -----------------------------------------------------------------
base_path = readlines("dir.conf")[1]
data_path = joinpath(base_path, "data")
code_path = joinpath(base_path, "code", "jcode")
rcode_path = joinpath(base_path, "code", "rcode")
## --- Load packages ------------------------------------------------------------
using LaTeXTabulars
using CSV

vd = CSV.read(joinpath(rcode_path, "output_table/variance_decomposition.csv"))
mat = convert(Matrix,vd)

latex_tabular(joinpath(rcode_path, "output_table/variance_decomposition.tex"),
              Tabular("lcccccccccc"),
              [Rule(:top),
               string.(names(vd)),
               Rule(:mid),
               repeat([""], inner=10),
               [MultiColumn(2,:l, "Press release")],
               repeat([""], inner=10),
               mat[1:2,:],
               CMidRule(1,9),
               mat[3,:],
               repeat([""], inner=10),
               [MultiColumn(2, :l, "Conference")],
               repeat([""], inner=10),
               mat[4:7,:],
               CMidRule(1,9),
               mat[8,:],
               Rule(:bottom)])


