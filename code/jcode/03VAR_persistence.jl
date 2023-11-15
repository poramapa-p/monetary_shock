# VAR Persistence -- Sovereing bond

## --- Set path -----------------------------------------------------------
base_path = readlines("dir.conf")[1]
data_path = joinpath(base_path, "data")
code_path = joinpath(base_path, "code", "jcode")

## --- Load packages ------------------------------------------------------
using DataFrames
using GrowableArrays
using Combinatorics
using CSV
using Dates
using Plots
gr();

## --- Load functions -----------------------------------------------------
include(joinpath(code_path, "99VAR_helpers.jl"));

## --- Load data
tData = CSV.read(joinpath(data_path, "vardailydataset.csv"))

## --- Set hyperparameter -------------------------------------------------
H    = 1000
nrep = 1000
p    = 1
nCI = 4;

#----Preallocate-----------------------------------------------------------

mOIS = Array{Float64}(undef, H+1, 1+nCI*2, 4);

## --- Start VAR loop -----------------------------------------------------
start_crisis = findall(tData.Date .== DateTime("2008-01-03"))[1]
start_pre_crisis = findall(tData.Date .== DateTime("2002-01-03"))[1]
start_qe = findall(tData.Date .== DateTime("2014-01-03"))[1];
start_ils = findfirst(!ismissing,tData.ILS2Y);

# --- QE sample -----------------------------------------------------------
mBond = Array{Float64}(undef,H+1,1+nCI*2,4,4);

global iCount = 0

for i in [:DE10Y; :IT10Y; :FR10Y; :ES10Y]
    println(i)
    global iCount +=1
    sVar =  [i; :LOGSTOXX; :LOGEURUSD; :ILS2Y]
    vIndex = sVar[1:end]

    # Target
    X = convert(Matrix{Float64},tData[start_ils:end,vIndex])
    Z = convert(Matrix{Float64},tData.Target[start_ils:end,:])
    IRF, A0inv,  B, U = irf_ext(X, Z, p, H)
    l, u    = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
    mOIS[:,:,1] = [IRF[:,1] l[:,:,1] u[:,:,1]]

    # Timing
    X = convert(Matrix{Float64}, tData[start_ils:end,vIndex])
    Z = convert(Matrix{Float64} ,tData.Timing[start_ils:end,:])
    IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
    l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
    mOIS[:,:,2] = [IRF[:,1] l[:,:,1] u[:,:,1]]

    # FG
    X = convert(Matrix{Float64}, tData[start_ils:end,vIndex])
    Z = convert(Matrix{Float64} ,tData.FG[start_ils:end,:])
    IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
    l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
    mOIS[:,:,3] = [IRF[:,1] l[:,:,1] u[:,:,1]]

    # QE
    X = convert(Matrix{Float64}, tData[start_qe:end,vIndex])
    Z = convert(Matrix{Float64}, tData.QE[start_qe:end,:])
    IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
    l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
    mOIS[:,:,4]     = [IRF[:,1] l[:,:,1] u[:,:,1]];

    mBond[:,:,:,iCount] = mOIS;
end

##--- FIGURE 7 - Sovereign-bond persistence ------------------------------

## Data and parameters for the plot

t, q, k = size(mOIS)
z_line = repeat([0.0],t,1)
c1  = repeat(["red"],1,9)
c2  = repeat(["blue"],1,9)
l1  = [:solid repeat([:dot],1,8)]
nFactor = 4

# Subplot
irf_rob = plot(layout = grid(4,nFactor),size = (1000,800))
for i in 1:nFactor
    (i != 1) ? (c = c2) : (c = c1)
    plot!(subplot = 1, title = "Target")
    plot!(subplot = 2, title = "Timing")
    plot!(subplot = 3, title = "FG")
    plot!(subplot = 4, title = "QE")
    plot!(irf_rob, -15/100*mBond[:,:,i,1], color=c, style=l1, legend=false,
          subplot = i,xlims = (0,t),ylabel="DE")
    plot!(irf_rob, -15/100*mBond[:,:,i,2], color=c, style=l1, legend=false,
          subplot = i+nFactor,xlims = (0,t),ylabel="IT")
    plot!(irf_rob, -15/100*mBond[:,:,i,3], color=c, style=l1, legend=false,
          subplot = i+nFactor*2,xlims = (0,t),ylabel="FR")
    plot!(irf_rob, -15/100*mBond[:,:,i,4], color=c, style=l1, legend=false,
          subplot = i+nFactor*3,xlims = (0,t),ylabel="ES",xlabel="days")

    plot!(irf_rob, z_line,color = "black",legend = false,subplot = i)
    plot!(irf_rob, z_line,color = "black",legend = false,subplot = i+nFactor)
    plot!(irf_rob, z_line,color = "black",legend = false,subplot = i+nFactor*2)
    plot!(irf_rob, z_line,color = "black",legend = false,subplot = i+nFactor*3)
end

# Save plot
irf_rob
png(joinpath(code_path, "output_figure/persistence_fg_qe.png"))
