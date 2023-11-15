################################################################################
## This file is part of the replication suite  of
## "Measuring Euro Area Monetary Policy"
## By Carlo Altavilla, Luca Brugnolini, Refet S. Gürkaynak, Roberto Motto, and
## Giuseppe Ragusa
##
## This file produces variance_decomposition.csv which is then used to generate 
## Table 3 in the paper.
##
################################################################################



library(pacman)

pacman::p_load(tidyverse, Hmisc, install = TRUE)

base_path <- read_lines("dir.conf")
code_path <- paste0(base_path, "/code/rcode")

## ---- TABLE 3 -- Variance decomposition ----------------------------------
dataset_rel <- read_csv(paste0(base_path, "/data/dataset_rel.csv"))
dataset_con <- read_csv(paste0(base_path, "/data/dataset_con.csv"))
dataset_rel <- dataset_rel %>%
  select(`1M`, `3M`, `6M`, `1Y`, `2Y`, `5Y`, `10Y`, `RateFactor1`)

dataset_con <- dataset_con %>%
  select(`1M`,
         `3M`,
         `6M`,
         `1Y`,
         `2Y`,
         `5Y`,
         `10Y`,
         `ConfFactor1`,
         `ConfFactor2`,
         `ConfFactor3`)

A1 <- anova(lm(`1M`~ RateFactor1, data = dataset_rel))
A2 <- anova(lm(`3M`~ RateFactor1, data = dataset_rel))
A3 <- anova(lm(`6M`~ RateFactor1, data = dataset_rel))
A4 <- anova(lm(`1Y`~ RateFactor1, data = dataset_rel))
A5 <- anova(lm(`2Y`~ RateFactor1, data = dataset_rel))
A6 <- anova(lm(`5Y`~ RateFactor1, data = dataset_rel))
A7 <- anova(lm(`10Y`~RateFactor1, data = dataset_rel))

B1 <- anova(lm(`1M` ~ConfFactor1 + ConfFactor2 + ConfFactor3, 
               data = dataset_con))
B2 <- anova(lm(`3M` ~ConfFactor1 + ConfFactor2 + ConfFactor3, 
               data = dataset_con))
B3 <- anova(lm(`6M` ~ConfFactor1 + ConfFactor2 + ConfFactor3, 
               data = dataset_con))
B4 <- anova(lm(`1Y` ~ConfFactor1 + ConfFactor2 + ConfFactor3, 
               data = dataset_con))
B5 <- anova(lm(`2Y` ~ConfFactor1 + ConfFactor2 + ConfFactor3, 
               data = dataset_con))
B6 <- anova(lm(`5Y` ~ConfFactor1 + ConfFactor2 + ConfFactor3, 
               data = dataset_con))
B7 <- anova(lm(`10Y`~ConfFactor1 + ConfFactor2 + ConfFactor3, 
               data = dataset_con))

sd_asset_rel <- sapply(dataset_rel,sd)[1:7] 
sd_asset_con <- sapply(dataset_con,sd)[1:7] 
sd_target <- sapply(dataset_rel,sd)[8]
sd_conffactor <- sapply(dataset_con,sd)[8:10]


tbl <- rbind(cbind(A1[,2]/sum(A1[,2]),
                   A2[,2]/sum(A2[,2]),
                   A3[,2]/sum(A3[,2]),
                   A4[,2]/sum(A4[,2]),
                   A5[,2]/sum(A5[,2]),
                   A6[,2]/sum(A6[,2]),
                   A7[,2]/sum(A7[,2])),
                   as.array(sd_asset_rel),
             cbind(B1[,2]/sum(B1[,2]),
                   B2[,2]/sum(B2[,2]),
                   B3[,2]/sum(B3[,2]),
                   B4[,2]/sum(B4[,2]),
                   B5[,2]/sum(B5[,2]),
                   B6[,2]/sum(B6[,2]),
                   B7[,2]/sum(B7[,2])),
                   as.array(sd_asset_con))



tbl <- cbind(tbl, c(sd_target/100, NA, NA, sd_conffactor/100, NA, NA))



colnames(tbl) <- c("1-month", "3-month", "6-month", "1-year", 
                   "2-year", "5-year", "10-year", "SD Factor")

rownames(tbl) <- c("Target", "Residual", "SD OIS rel.",
                   "Timing", "Forward Guidance", "QE", 
                   "Residual", "SD OIS conf.")

fdf = format.df(tbl*100, dec = 1)
write.csv(fdf, paste0(code_path, "/output_table/variance_decomposition.csv"))

# out <- latex(fdf,
#       file = paste0(code_path, "output_table/variance_decomposition.csv"))
