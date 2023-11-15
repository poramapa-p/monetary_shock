#!/usr/local/bin/julia

## Read dir.conf

base_path = readlines("dir.conf")[1]
code_path = joinpath(base_path, "code/jcode")
data_path = joinpath(base_path, "data")
using Pkg
Pkg.activate(code_path)
Pkg.instantiate()
Pkg.update()
## --- Load packages -----------------------------------------------------------
using Factotum
using MathProgBase
using ForwardDiff
using Ipopt
using DataFrames
using CSV
using Statistics
using LinearAlgebra
using Dates

## --- Load functions -----------------------------------------------------------

include(joinpath(code_path,"00rotate_helpers.jl"))

## --- Load data -----------------------------------------------------------

Xrel = CSV.read(joinpath(data_path,"Xrel.csv"), header=false)
Drel = CSV.read(joinpath(data_path,"Drel.csv"), header=false)

Xcon = CSV.read(joinpath(data_path,"Xcon.csv"), header=false)
Dcon = CSV.read(joinpath(data_path,"Dcon.csv"), header=false)

## --- Rotate factor -----------------------------------------------------------
RotatedOutput_rel = rotate3(convert(Matrix, Xrel), Drel, Date(2008, 09, 04))
RotatedOutput_con = rotate3(convert(Matrix, Xcon), Dcon, Date(2008, 09, 04))

RotatedFactor_rel = RotatedOutput_rel[1]
RotatedFactor_conf = RotatedOutput_con[1]

## --- Create dataframes -----------------------------------------------------------

df_RotatedFactor_rel = DataFrame(Date = Drel[:,1],
                   RateFactor1 = RotatedFactor_rel[:,1])

df_RotatedFactor_conf = DataFrame(Date = Dcon[:,1],
                    ConfFactor1 = RotatedFactor_conf[:,1],
                    ConfFactor2 = RotatedFactor_conf[:,2],
                    ConfFactor3 = RotatedFactor_conf[:,3])

## --- Save dataframes -----------------------------------------------------------
CSV.write(joinpath(data_path,"df_RotatedFactor_rel.csv"), df_RotatedFactor_rel)
    CSV.write(joinpath(data_path,"df_RotatedFactor_con.csv"), df_RotatedFactor_conf)
