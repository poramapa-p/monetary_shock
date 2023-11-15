# VAR Persistence -- Robustness using combinations

## --- Set path -----------------------------------------------------------------
base_path = readlines("dir.conf")[1]
data_path = joinpath(base_path, "data")
code_path = joinpath(base_path, "code", "jcode")

## --- Load packages ------------------------------------------------------------
using DataFrames
using GrowableArrays
using Combinatorics
using CSV
using Dates
using Plots
gr();

## --- Load functions -----------------------------------------------------------
include(joinpath(code_path, "99VAR_helpers.jl"));

## --- Load data
tData = CSV.read(joinpath(data_path, "vardailydataset.csv"))

## --- Set hyperparameter -------------------------------------------------------
H = 1000
nrep = 250
p = 1
nCI = 4

#----Preallocate-----------------------------------------------------------------
mOIS = Array{Float64}(undef,H+1,1+nCI*2,4);

## --- Start VAR ----------------------------------------------------------------
start_crisis = findall(tData.Date .== DateTime("2008-01-03"))[1]
start_pre_crisis = findall(tData.Date .== DateTime("2002-01-03"))[1]
start_qe = findall(tData.Date .== DateTime("2014-01-03"))[1];
start_ils = findfirst(!ismissing,tData.ILS2Y);

comb = collect(combinations(2:8));
ncomb = size(comb)[1]

iMin_VAR_variables = 3
iMax_var = 7
mBond = Array{Float64}(undef,H+1,1+nCI*2,4,ncomb*8)


global iCount = 0

for i in [:DE10Y; :IT10Y; :FR10Y; :ES10Y ; :OIS10Y; :EA10Y; :EA10YAAA; :GOV10Y]
    start_dep = findfirst(!ismissing,tData[i])
    println(i)
    sVar =  [i; :LOGSTOXX; :LOGEURUSD; :SPREAD_BBB_AAA; :OIS2Y; :GOV5Y; :VIXEA;:ILS2Y]
    for j in comb
        global iCount += 1
        k = [1;j]
        vIndex = sVar[k]
        if sum(8 .== k) == 0
            start_var = start_dep
        else
            start_var = max(start_dep,start_ils)
        end

        println("combination $iCount date is $(start_var) comb var is $(k)")

        # Target
        X = convert(Matrix{Float64},tData[start_var:end,vIndex])
        Z = convert(Matrix{Float64},tData.Target[start_var:end,:])

        IRF, A0inv,  B, U = irf_ext(X, Z, p, H)
        l, u    = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
        mOIS[:,:,1] = [IRF[:,1] l[:,:,1] u[:,:,1]]

        # Timing
        X = convert(Matrix{Float64},tData[start_var:end,vIndex])
        Z = convert(Matrix{Float64},tData.Timing[start_var:end,:])
        IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
        l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
        mOIS[:,:,2] = [IRF[:,1] l[:,:,1] u[:,:,1]]

        # FG
        X = convert(Matrix{Float64},tData[start_var:end,vIndex])
        Z = convert(Matrix{Float64},tData.FG[start_var:end,:])
        IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
        l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
        mOIS[:,:,3] = [IRF[:,1] l[:,:,1] u[:,:,1]]

        # QE
        X = convert(Matrix{Float64},tData[start_qe:end,vIndex])
        Z = convert(Matrix{Float64},tData.QE[start_qe:end,:])
        IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
        l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
        mOIS[:,:,4]     = [IRF[:,1] l[:,:,1] u[:,:,1]];

        mBond[:,:,:,iCount] = mOIS
    end
end

t,q,k,d = size(mBond)

##--- FIGURE 8 - Persistence robustness -----------------------------------------

# Data and parameters for the plot
t,q,k,d = size(mBond)
z_line = repeat([0.0],t,1)
c1  = repeat(["red"],1,d+1)
c2  = repeat(["blue"],1,d+1)
l1  = [:solid repeat([:dot],1,d)]
nFactor = 4


# Subplot
irf_rob = plot(layout = grid(2,1),size = (1000,800))

for i in 1:d
    println(i)
    (i != 1) ? (c = c2) : (c = c1)
    plot!(subplot = 1, title = "FG")
    plot!(subplot = 2, title = "QE")
    plot!(irf_rob, -15/100*mBond[:,:,3,i], color=c2, style=l1, legend=false, subplot = 1,xlims = (0,t),ylabel="")
    plot!(irf_rob, -15/100*mBond[:,:,4,i], color=c2, style=l1, legend=false, subplot = 2,xlims = (0,t),ylabel="",xlabel="days")

    plot!(irf_rob, z_line,color = "black",legend = false,subplot = 1)
    plot!(irf_rob, z_line,color = "black",legend = false,subplot = 2)
end

# Save plot
irf_rob
png(joinpath(code_path, "output_figure/persistence_rob_fg_qe.png"))
