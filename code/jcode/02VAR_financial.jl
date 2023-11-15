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

## --- Set hyper-parameter -------------------------------------------------------
H = 1000
nrep = 10
p = 12
nCI = 4;

# -------------------------------------------------------------------------------
# QE sample
# -------------------------------------------------------------------------------

#--- Preallocate ----------------------------------------------------------------

mOIS = Array{Float64}(undef,H+1,1+nCI*2,4)
mSTOXX = Array{Float64}(undef,H+1,1+nCI*2,4)
mEUR = Array{Float64}(undef,H+1,1+nCI*2,4)
mILS = Array{Float64}(undef,H+1,1+nCI*2,4)

## --- Start VAR  -----------------------------------------------------------
start_qe = findall(tData.Date .== DateTime("2014-01-03"))[1]
sVar =  [:OIS2Y; :LOGSTOXX; :LOGEURUSD; :ILS2Y]
nVar = length(sVar);

j = 4
vIndex = sVar[1:j]

# Target
X = convert(Matrix{Float64},tData[start_qe:end,vIndex])
Z = convert(Matrix{Float64},tData.Target[start_qe:end,:]);

IRF, A0inv,  B, U = irf_ext(X, Z, p, H)
l, u    = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS[:,:,1] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX[:,:,1] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR[:,:,1] = [IRF[:,3] l[:,:,3] u[:,:,3]]
mILS[:,:,1] = [IRF[:,4] l[:,:,4] u[:,:,4]]

# Timing
X = convert(Matrix{Float64},tData[start_qe:end,vIndex])
Z = convert(Matrix{Float64},tData.Timing[start_qe:end,:])
IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS[:,:,2] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX[:,:,2] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR[:,:,2] = [IRF[:,3] l[:,:,3] u[:,:,3]]
mILS[:,:,2] = [IRF[:,4] l[:,:,4] u[:,:,4]]

# FG
X = convert(Matrix{Float64},tData[start_qe:end,vIndex])
Z = convert(Matrix{Float64},tData.FG[start_qe:end,:])
IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS[:,:,3] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX[:,:,3] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR[:,:,3] = [IRF[:,3] l[:,:,3] u[:,:,3]]
mILS[:,:,3] = [IRF[:,4] l[:,:,4] u[:,:,4]]

# QE
X = convert(Matrix{Float64},tData[start_qe:end,vIndex])
Z = convert(Matrix{Float64},tData.QE[start_qe:end,:])
IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS[:,:,4]     = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX[:,:,4]   = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR[:,:,4]     = [IRF[:,3] l[:,:,3] u[:,:,3]]
mILS[:,:,4] = [IRF[:,4] l[:,:,4] u[:,:,4]]

#------------------------------------------------------------------------
# PRE-QE SAMPLE
#------------------------------------------------------------------------

#----Preallocate-----------------------------------------------------------------
mOIS1 = Array{Float64}(undef,H+1,1+nCI*2,4)
mSTOXX1 = Array{Float64}(undef,H+1,1+nCI*2,4)
mEUR1 = Array{Float64}(undef,H+1,1+nCI*2,4)
mILS1 = Array{Float64}(undef,H+1,1+nCI*2,4);

## --- Start VAR -----------------------------------------------------------
sVar =  [:OIS2Y; :LOGSTOXX; :LOGEURUSD; :ILS2Y]
nVar = length(sVar);
start_crisis = findall(tData.Date .== DateTime("2008-01-03"))[1]
start_qe = findall(tData.Date .== DateTime("2014-01-03"))[1];

j = 4
vIndex = sVar[1:j]

# Target
X = convert(Matrix,tData[start_crisis:start_qe,vIndex])
Z = convert(Matrix,tData.Target[start_crisis:start_qe,:])

IRF, A0inv,  B, U = irf_ext(X, Z, p, H)
l, u    = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS1[:,:,1] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX1[:,:,1] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR1[:,:,1] = [IRF[:,3] l[:,:,3] u[:,:,3]]
mILS1[:,:,1] = [IRF[:,4] l[:,:,4] u[:,:,4]]

# Timing
X = convert(Matrix,tData[start_crisis:start_qe,vIndex])
Z = convert(Matrix,tData.Timing[start_crisis:start_qe,:])
IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS1[:,:,2] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX1[:,:,2] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR1[:,:,2] = [IRF[:,3] l[:,:,3] u[:,:,3]]
mILS1[:,:,2] = [IRF[:,4] l[:,:,4] u[:,:,4]]

# FG
X = convert(Matrix,tData[start_crisis:start_qe,vIndex])
Z = convert(Matrix,tData.FG[start_crisis:start_qe,:])
IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS1[:,:,3] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX1[:,:,3] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR1[:,:,3] = [IRF[:,3] l[:,:,3] u[:,:,3]]
mILS1[:,:,3] = [IRF[:,4] l[:,:,4] u[:,:,4]];

# ----------------------------------------------------------------------------
# PRE CRISIS
# ----------------------------------------------------------------------------

#----Preallocate-----------------------------------------------------------------
mOIS2 = Array{Float64}(undef,H+1,1+nCI*2,4)
mSTOXX2 = Array{Float64}(undef,H+1,1+nCI*2,4)
mEUR2 = Array{Float64}(undef,H+1,1+nCI*2,4)

## --- Start VAR  -----------------------------------------------------------
sVar =  [:OIS2Y; :LOGSTOXX; :LOGEURUSD]
nVar = length(sVar);
start_crisis = findall(tData.Date .== DateTime("2008-01-03"))[1]
start_pre_crisis = findall(tData.Date .== DateTime("2002-01-03"))[1];

j = 3
vIndex = sVar[1:j]

# Target
X = convert(Matrix,tData[start_pre_crisis:start_crisis,vIndex])
Z = convert(Matrix,tData.Target[start_pre_crisis:start_crisis,:])

IRF, A0inv,  B, U = irf_ext(X, Z, p, H)
l, u    = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS2[:,:,1] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX2[:,:,1] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR2[:,:,1] = [IRF[:,3] l[:,:,3] u[:,:,3]]

# Timing
X = convert(Matrix,tData[start_pre_crisis:start_crisis,vIndex])
Z = convert(Matrix,tData.Timing[start_pre_crisis:start_crisis,:])
IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS2[:,:,2] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX2[:,:,2] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR2[:,:,2] = [IRF[:,3] l[:,:,3] u[:,:,3]]

# FG
X = convert(Matrix,tData[start_pre_crisis:start_crisis,vIndex])
Z = convert(Matrix,tData.FG[start_pre_crisis:start_crisis,:])
IRF, A0inv, B, U  = irf_ext(X, Z, p, H)
l, u = boot_wild_all(B, U, X, Z, p, H, nrep, [.05, .10, .15, .25])
mOIS2[:,:,3] = [IRF[:,1] l[:,:,1] u[:,:,1]]
mSTOXX2[:,:,3] = [IRF[:,2] l[:,:,2] u[:,:,2]]
mEUR2[:,:,3] = [IRF[:,3] l[:,:,3] u[:,:,3]]

# ------------------------------------------------------------------------------
# FIGURE 6 - Financial VAR IRF
# ------------------------------------------------------------------------------
# Data and parameters for the plot
t,q,k = size(mOIS)
z_line = repeat([0.0],t,1)
c   = "red"
c1  = "green"
c2  = "blue"

l   = :dash
l1  = :dashdot
l2  = :dot

nFactor = 4

# Subplot
irf_rob = plot(layout = grid(4,nFactor),size = (1000,800))
for i in 1:nFactor
        plot!(subplot = 1, title = "Target")
        plot!(subplot = 2, title = "Timing")
        plot!(subplot = 3, title = "FG")
        plot!(subplot = 4, title = "QE")

        i == 1 ? (leg = false) : (leg = false)
        plot!(irf_rob, 15/100*mOIS[:,1,i], color=c, style=l, legend=leg, linewidth = 3, subplot = i,xlims = (0,t),ylabel="OIS2Y (%)", label = "2014-2018")
        if i < 4
                plot!(irf_rob, 15/100*mOIS1[:,1,i], color=c1, style=l1, legend=leg, linewidth = 3, subplot = i,xlims = (0,t),ylabel="OIS2Y (%)", label = "2008-2014")
                plot!(irf_rob, 15/100*mOIS2[:,1,i], color=c2, style=l2, legend=leg, linewidth = 3, subplot = i,xlims = (0,t),ylabel="OIS2Y (%)", label = "2002-2008")
        end

        plot!(irf_rob, 15/100*mSTOXX[:,1,i], color=c, style=l,   linewidth = 3, subplot = i+nFactor,xlims = (0,t),ylabel="STOXX (%)")
        if i < 4
                plot!(irf_rob, 15/100*mSTOXX1[:,1,i], color=c1, style=l1,  linewidth = 3, subplot = i+nFactor,xlims = (0,t),ylabel="STOXX (%)")
                plot!(irf_rob, 15/100*mSTOXX2[:,1,i], color=c2, style=l2,   linewidth = 3, subplot = i+nFactor,xlims = (0,t),ylabel="STOXX (%)")
        end

        plot!(irf_rob, 15/100*mEUR[:,1,i], color=c, style=l,  linewidth = 3, subplot = i+nFactor*3,xlims = (0,t),ylabel="EUR (%)")
        if i < 4
                plot!(irf_rob, 15/100*mEUR1[:,1,i], color=c1, style=l1, linewidth = 3, subplot = i+nFactor*3,xlims = (0,t),ylabel="EUR (%)")
                plot!(irf_rob, 15/100*mEUR2[:,1,i], color=c2, style=l2,  linewidth = 3, subplot = i+nFactor*3,xlims = (0,t),ylabel="EUR (%)")
        end

        plot!(irf_rob, 15/100*mILS[:,1,i], color=c, style=l,  linewidth = 3, subplot = i+nFactor*2,xlims = (0,t),ylabel="ILS2Y (%)",xlabel="days")
        if i < 4
                plot!(irf_rob, 15/100*mILS1[:,1,i], color=c1, style=l1,  linewidth = 3, subplot = i+nFactor*2,xlims = (0,t),ylabel="ILS2Y (%)",xlabel="days")
        end
        plot!(irf_rob, z_line,color = "black",legend = leg,subplot = i, label = "")
        plot!(irf_rob, z_line,color = "black",legend = false,subplot = i+nFactor)
        plot!(irf_rob, z_line,color = "black",legend = false,subplot = i+nFactor*2)
        plot!(irf_rob, z_line,color = "black",legend = false,subplot = i+nFactor*3)
end

# Save plot
irf_rob
png("code/jcode/output_figure/VAR_stock_multi_new_ln_rescaled.png")
