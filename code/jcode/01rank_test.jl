#################################################################################
# TABLE 2 - Rank test for number of factors
#################################################################################



using Factotum
using LinearAlgebra
using CSV
using Dates
using LaTeXTabulars
using Formatting

base_path = readlines("dir.conf")[1]
data_path = joinpath(base_path, "data")
code_path = joinpath(base_path, "code", "jcode")


Xrel = CSV.read(joinpath(data_path,"Xrel.csv"), header=false)
Drel = CSV.read(joinpath(data_path,"Drel.csv"), header=false)

Xcon = CSV.read(joinpath(data_path,"Xcon.csv"), header=false)
Dcon = CSV.read(joinpath(data_path,"Dcon.csv"), header=false)

## Test Release -- Whole Sample
ind_rel = findfirst(Drel[:,1].==Date(2014,01,09))
ind_con = findfirst(Dcon[:,1].==Date(2014,01,09))


rel_full = waldtest(Factotum.FactorModel(convert(Matrix, Xrel)), 0,3)
rel_pre  = waldtest(Factotum.FactorModel(convert(Matrix, Xrel)[1:ind_rel-1,:]), 0, 3)

con_full = waldtest(Factotum.FactorModel(convert(Matrix, Xcon)), 0, 3)
con_pre  = waldtest(Factotum.FactorModel(convert(Matrix, Xcon)[1:ind_con-1,:]), 0, 3)


t = convert(Array{Any,2}, [con_pre.tbl.waldstat con_full.tbl.waldstat])
t = format.(t, precision = 2)
t[4,1] = ""

t = convert(Array{Any,2}, [con_pre.tbl.waldstat con_full.tbl.waldstat])
t = format.(t, precision = 2)
t[4,1] = ""

s = convert(Array{Any,2}, [con_pre.tbl.pvalue con_full.tbl.pvalue])
s = format.(s, precision = 3)

fs(x) = "("*x*")"
s = fs.(s)
s[4,1] = ""


pt = convert(Array{Any,2}, [rel_pre.tbl.waldstat rel_full.tbl.waldstat])
pt = format.(pt, precision = 2)
pt[4,1] = ""

pt = convert(Array{Any,2}, [rel_pre.tbl.waldstat rel_full.tbl.waldstat])
pt = format.(pt, precision = 2)
pt[3:4,1:2] .= ""

ps = convert(Array{Any,2}, [rel_pre.tbl.pvalue rel_full.tbl.pvalue])
ps = format.(ps, precision = 3)

fs(x) = "("*x*")"
ps = fs.(ps)
ps[3:4,1:2] .= ""


TestMat = [
    "\$H_{0}:k=0\$" "" pt[1,1] pt[1,2] "" t[1,1] t[1,2] "";
                 "" "" ps[1,1] ps[1,2] "" s[1,1] s[1,2] "";
    "\$H_{0}:k=1\$" "" pt[2,1] pt[2,2] "" t[2,1] t[2,2] "";
                 "" "" ps[2,1] ps[2,2] "" s[2,1] s[2,2] "";
    "\$H_{0}:k=2\$" "" pt[3,1] pt[3,2] "" t[3,1] t[3,2] "";
                 "" "" ps[3,1] ps[3,2] "" s[3,1] s[3,2] "";
    "\$H_{0}:k=3\$" "" pt[4,1] pt[4,2] "" t[4,1] t[4,2] "";
                 "" "" ps[4,1] ps[4,2] "" s[4,1] s[4,2] "" ]

## Construct Table
latex_tabular(joinpath(code_path, "output_table/rank_test.tex"),
              Tabular("cccccccc"),
              [repeat([""], inner=8),
               Rule(:mid),
               ["", "", MultiColumn(2, :c, "Press Release Window"), "", MultiColumn(2, :c, "Conference Window"), ""],
               Rule(:mid),
               ["", "", "Pre-QE", "Full sample", "", "Pre-QE", "Full sample"],
               CMidRule(3,4), CMidRule(6,7),
               repeat([""], inner=8),
               TestMat,
               Rule(:bottom)])


