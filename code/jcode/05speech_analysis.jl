# Speech analysis

## --- Set path -----------------------------------------------------------------
base_path = readlines("dir.conf")[1]
data_path = joinpath(base_path, "data")
code_path = joinpath(base_path, "code", "jcode")
raw_path = joinpath(base_path, "raw_data")

# Load packages
using DataFrames
using CSV
using Query
using Dates
using StatsPlots
using Statistics
using Plots
gr()

# Import data

tAsset  = CSV.read(joinpath(raw_path, "06speech_asset_change.csv"))
loading = CSV.read(joinpath(data_path,"loadings_unscaled.csv"))


tAsset = tAsset[1:2,:]
sHead = [:Date,:OIS1M,:OIS3M,:OIS6M,:OIS1Y,:OIS2Y,:OIS5Y,:OIS10Y]
names!(tAsset, sHead)
iSpeech = size(tAsset,1)

mAsset = convert(Matrix{Float64},tAsset[2:end])
tData = DataFrame(repeat([Float64],4),names(loading),iSpeech);

for j = 1:iSpeech
  # Scaled factors using OLS
  target_s = (loading[:Target]\mAsset[j,:])*loading[:Target][1]
  timing_s = (loading[:Timing]\mAsset[j,:])*loading[:Timing][3]
  fg_s     = (loading[:FG]\mAsset[j,:])*loading[:FG][5]
  qe_s     = (loading[:QE]\mAsset[j,:])*loading[:QE][7]
  tData[:Target][j] = target_s
  tData[:Timing][j] = timing_s
  tData[:FG][j] = fg_s
  tData[:QE][j] = qe_s
end

# Compare estimated factor in-sample with factor timeseries
mFactor = CSV.read(joinpath(data_path, "dailydataset.csv"))
mFactor1 = @from i in mFactor begin
  @select {Target=i.RateFactor1,Timing=i.ConfFactor1,FG=i.ConfFactor2,QE=i.ConfFactor3}
  @collect DataFrame
end

vAvg_abs_size = Array{Float64}(undef,4,1)
global iCount = 0
for i in [:Target :Timing :FG :QE]
  global iCount += 1
	vAvg_abs_size[iCount] = Statistics.mean(abs.(collect(skipmissing(mFactor1[i]))))
end

tData_final = convert(Matrix{Float64},tData)./vAvg_abs_size'


# FIGURE 9 - Yield curves for speech events
x_ax = [1/12, 3/12, 6/12, 1, 2, 5, 10]
pCurve = plot(layout = grid(2,1),size = (800,600))
plot!(pCurve,x_ax, mAsset[1,:], ylim = (0,3),
			subplot = 1,legend = false,color = "red", linewidth = 3,
			markershape = :circle, title = "27-Jun-2017", markersize = 6,
			xticks = (x_ax, ["1M", "", "6M", "1Y", "2Y", "5Y", "10Y"]))
plot!(pCurve,x_ax, mAsset[2,:], ylim = (0,3),
			subplot = 2,legend = false,color = "blue", linewidth = 3, markersize = 6,
			markershape = :circle, title = "04-Oct-2016",
			xticks = (x_ax, ["1M", "", "6M", "1Y", "2Y", "5Y", "10Y"]))

# Save plot
pCurve
png(joinpath(code_path, "output_figure/Figure9.png"))



# FIGURE 10 - Estimated factor from speech
pSpeech = plot(layout = grid(2,3), size = (800,600))

bar!(pSpeech, ["27jun17","04oct16"], tData_final[1:2,1],  ylims = [-1,3],
		 rotation = 45, color = "red", subplot = 1, title = "Target", legend = false)

bar!(pSpeech,xaxis = false, yaxis = false, subplot = 2)
bar!(pSpeech,xaxis = false, yaxis = false, subplot = 3)

bar!(pSpeech,["27jun17","04oct16"], tData_final[1:2,2], ylims = [-1,3],
		 rotation = 45, color = "blue",subplot = 4, title = "Timing", legend = false)
bar!(pSpeech,["27jun17","04oct16"],tData_final[1:2,3], ylims = [-1,3], rotation = 45, color = "blue",subplot = 5, title = "FG", legend = false)
bar!(pSpeech,["27jun17","04oct16"],tData_final[1:2,4], ylims = [-1,3], rotation = 45, color = "blue",subplot = 6, title = "QE", legend = false)

# Save plot
pSpeech
png(joinpath(code_path, "output_figure/Figure10.png"))
