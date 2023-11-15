################################################################################
## This file is part of the replication suite  of
## "Measuring Euro Area Monetary Policy"
## By Carlo Altavilla, Luca Brugnolini, Refet S. Gürkaynak, Roberto Motto, and
## Giuseppe Ragusa
##
## This file produces Figure3 and Figure4 in the paper
##
################################################################################


library(pacman)

pacman::p_load(tidyverse, Hmisc, sandwich, gridExtra, lubridate, cowplot, install = TRUE)

base_path <- read_lines("dir.conf")
base_path <- "/home/gragusa/Dropbox/measuring_ea_monetary_policy_shock/replication_files"
data_path <- paste0(base_path, "/data/")
code_path <- paste0(base_path, "/code/rcode/")

rel <- read_csv(paste0(data_path, "dataset_rel.csv")) %>% 
  select(Date, contains("RateFactor1"))
con <- read_csv(paste0(data_path, "dataset_con.csv")) %>% 
  select(Date, starts_with("ConfF"))

bsz = 8

breaks_axis <- c(ymd("2002-01-01"),
                 ymd("2004-01-01"),
                 ymd("2006-01-01"),
                 ymd("2008-01-01"),
                 ymd("2010-01-01"),
                 ymd("2012-01-01"),
                 ymd("2014-01-01"),
                 ymd("2016-01-01"),
                 ymd("2018-09-01"))

dlabels <- c("%Y", rep("%y", 7), "%Y")

plot_rf1 <- ggplot(rel %>% filter(!is.na(RateFactor1)), aes(y=RateFactor1, x = Date)) +
  geom_bar(stat="identity", fill = "blue") +
  theme_minimal(base_size = bsz) + ylab("") + xlab("") + ggtitle("Target Factor") +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 10),
        axis.line = element_line(size = 0.5),
        panel.background = element_blank()) + ylim(c(-15, 15)) + 
  scale_x_date(breaks = breaks_axis, date_labels = dlabels)


plot_cf1 <- ggplot(con, aes(y=ConfFactor1, x = Date)) +
  geom_bar(stat="identity", fill = "red") +
  theme_minimal(base_size = bsz) + ylab("") + xlab("") + ggtitle("Timing Factor") +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 10),
        axis.line = element_line(size = 0.5),
        panel.background = element_blank()) + ylim(c(-15, 15)) + 
  scale_x_date(breaks = breaks_axis, date_labels = dlabels)

plot_cf2 <-  ggplot(con, aes(y=ConfFactor2, x = Date)) +
  geom_bar(stat="identity", fill = "red") +
  theme_minimal(base_size = bsz) + ylab("") +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 10),
        axis.line = element_line(size = 0.5),
        panel.background = element_blank()) +
  xlab("") + ggtitle("Forward Guidance Factor") + ylim(c(-30, 15)) + 
  scale_x_date(breaks = breaks_axis, date_labels = dlabels)

con <- con %>% mutate(CF30 = ifelse(Date>=ymd("2008-09-01"), ConfFactor3, 0))

plot_cf3 <- ggplot(con, aes(y=CF30, x = Date)) +
  geom_bar(stat="identity", fill = "red") +
  theme_minimal(base_size = bsz) + ylab("") +
  theme(panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 10),
        axis.line = element_line(size = 0.5),
        panel.background = element_blank()) +
  ylab("") + xlab("") +
  ggtitle("QE Factor") + ylim(c(-10, 10)) + 
  scale_x_date(breaks = breaks_axis, date_labels = dlabels)

a1 <- arrangeGrob(plot_rf1,  ggplot() + theme_minimal(), ggplot() + theme_minimal(),  ncol = 3)
a2 <- arrangeGrob(plot_cf1, plot_cf2, plot_cf3, ncol = 3)

ggsave(filename = paste0(code_path, "output_figure/Figure4.pdf"), 
       plot = ggdraw(arrangeGrob(a1, a2, nrow = 2, ncol = 1)),
       width = 6,
       height = 5,
       device = "pdf")

##### 



## ---- Plot theme amendements ------------------------------------------------------------
etheme <- theme(plot.margin=unit(c(1.,.2,.5,.2), "cm"), 
                axis.line = element_line(size = 0.75, linetype = "solid", colour = "black"),
                panel.grid.major = element_blank(), panel.grid.minor = element_blank())

bsp <- function(){
  function(x) {
    if (length(x) == 0)
      return(character())
    x <- plyr::round_any(x*100, 2)
    paste0(x)
  }
}

bsp <- function(){
  function(x) x*100
}

## ---- Factor naming ------------------------------------------------------------

nmf1rd <- "Target factor"

nmf1pc <- "Timing"
nmf2pc <- "Forward Guidance"
nmf3pc <- "QE"

snmf1rd <- "Target"
snmf2rd <- "FG"
snmf3rd <- "QE"

snmf1pc <- "Timing"
snmf2pc <- "FG"
snmf3pc <- "QE"


dataset_rel <- read_csv(paste0(data_path, "dataset_rel.csv"))
dataset_con <- read_csv(paste0(data_path, "dataset_con.csv"))

dataset_tot <- left_join(dataset_rel, dataset_con, by = "Date") %>% 
  select(starts_with("Rate"), starts_with("Conf"))



## ---- Set-up regressions, factos on yields --------------------------------------------
frm_rel <- dataset_rel %>%
  select(-Date, -starts_with("Rate")) %>% 
  names() %>%
  paste0('`',.,'`', "~RateFactor1") %>% 
  map(as.formula) 

frm_pc <- dataset_con %>%  
  select( -Date, -starts_with("Conf")) %>% 
  names() %>% 
  paste0('`',.,'`', "~ConfFactor1") %>% 
  map(as.formula) 

frm_pc2 <- dataset_con %>%  
  select( -Date, -starts_with("Conf")) %>% 
  names() %>% 
  paste0('`',.,'`', "~ConfFactor2") %>% 
  map(as.formula) 

frm_pc3 <- dataset_con %>%  
  select( -Date, -starts_with("Conf")) %>% 
  names() %>% 
  paste0('`',.,'`', "~ConfFactor3") %>% 
  map(as.formula) 

## ---- Regressions, factors on yields --------------------------------------------------------------

lm_rel  <- map(frm_rel,  ~lm(., data = dataset_rel))

lm_pc  <- map(frm_pc,  ~lm(., data = dataset_con))
lm_pc2 <- map(frm_pc2, ~lm(., data = dataset_con))
lm_pc3 <- map(frm_pc3, ~lm(., data = dataset_con))

rel_coef  <- map(lm_rel, function(u) coef(u)[2])
rel_serr  <- map(lm_rel, function(u) sqrt(vcovHC(u)[2,2])) ## CHECK HERE

rel_r2  <- map(lm_rel, function(u) summary(u)$r.squared)

pc_coef  <- map(lm_pc, function(u) coef(u)[2])
pc_serr  <- map(lm_pc, function(u) sqrt(vcovHC(u)[2,2])) ## CHECK HERE
pc2_coef <- map(lm_pc2, function(u) coef(u)[2])
pc2_serr <- map(lm_pc2, function(u) sqrt(vcovHC(u)[2,2])) ## CHECK HERE
pc3_coef <- map(lm_pc3, function(u) coef(u)[2])
pc3_serr <- map(lm_pc3, function(u) sqrt(vcovHC(u)[2,2])) ## CHECK HERE

pc_r2  <- map(lm_pc,   function(u) summary(u)$r.squared)
pc2_r2 <- map(lm_pc2,  function(u) summary(u)$r.squared)
pc3_r2 <- map(lm_pc3, function(u) summary(u)$r.squared)

nm <- names(dataset_con)[1:7]

rel  <- as_data_frame(cbind(unlist(rel_coef),
                            unlist(rel_serr),
                            unlist(rel_r2))) %>% 
  rename(coef = V1, serr = V2, R2 = V3) %>% mutate(mat = nm)


pc   <- as_data_frame(cbind(unlist(pc_coef),
                            unlist(pc_serr),
                            unlist(pc_r2))) %>% 
  rename(coef = V1, serr = V2, R2 = V3) %>% mutate(mat = nm) 

pc2  <- as_data_frame(cbind(unlist(pc2_coef),
                            unlist(pc2_serr),
                            unlist(pc2_r2))) %>% 
  rename(coef = V1, serr = V2, R2 = V3) %>% mutate(mat = nm) 

pc3  <- as_data_frame(cbind(unlist(pc3_coef),
                            unlist(pc3_serr),
                            unlist(pc3_r2))) %>% 
  rename(coef = V1, serr = V2, R2 = V3) %>% mutate(mat = nm) 


nmm <- c(1, 3, 6, 12, 24, 60, 120)

release_footprint_1 <- ggplot(rel, aes(y=coef, x=nmm)) + 
  geom_point(col = "blue", size = 1) +
  geom_line(col = "blue", lwd = .8) + 
  geom_ribbon(aes(ymin = coef-1.64*serr, ymax = coef+1.64*serr), fill = "darkblue", alpha=0.35) +
  scale_x_continuous(breaks = nmm[c(1, 5, 6, 7)], labels = nm[c(1, 5, 6, 7)]) +
  scale_y_continuous(labels=bsp(), limits = c(-0.5/100, 0.016), 
                     breaks = c(0,  .5,  1,  1.5 )/100) +
   xlab("") + ylab("") + 
  theme_minimal(base_size=9) + 
  etheme +  xlab("") +
  ggtitle(snmf1rd) + geom_hline(yintercept=0, color='black', lty = 4)


conference_footprint_1 <- ggplot(pc, aes(y=coef, x=nmm)) + 
  geom_point(col = "red", size = 1) +
  geom_line(col = "red", lwd = .8) + 
  # geom_line(aes(y=coef-1.96*serr), col = 'darkred', linetype = 2) + 
  # geom_line(aes(y=coef+1.96*serr), col = 'darkred', linetype = 2) +
  geom_ribbon(aes(ymin = coef-1.64*serr, ymax = coef+1.64*serr), fill = "red", alpha=0.35) +
  scale_x_continuous(breaks = nmm[c(1, 5, 6, 7)], labels = nm[c(1, 5, 6, 7)]) +
  scale_y_continuous(labels=bsp(), limits = c(-0.1/100, 0.016), 
                     breaks = c(0,  .5,  1,  1.5 )/100) +
  xlab("") + ylab("") + 
  theme_minimal(base_size=9) + etheme + 
  geom_hline(yintercept=0, color='black', lty = 4) +
  ggtitle(snmf1pc) 

conference_footprint_2 <- ggplot(pc2, aes(y=coef, x=nmm)) + 
  geom_point(col = "red", size = 1) +
  geom_line(col = "red", lwd = .8) + 
  # geom_line(aes(y=coef-1.96*serr), col = 'darkred', linetype = 2) + 
  # geom_line(aes(y=coef+1.96*serr), col = 'darkred', linetype = 2) + 
  geom_ribbon(aes(ymin = coef-1.64*serr, ymax = coef+1.64*serr), fill = "red", alpha=0.35) +
  scale_x_continuous(breaks = nmm[c(1, 5, 6, 7)], labels = nm[c(1, 5, 6, 7)]) +
  scale_y_continuous(labels=bsp(), limits = c(-0.1/100, 0.016), 
                     breaks = c(0,  .5,  1,  1.5 )/100) +
  xlab("") + ylab("") + 
  theme_minimal(base_size=9) + etheme + 
  geom_hline(yintercept=0, color='black', lty = 4) +
  ggtitle(snmf2pc) 

conference_footprint_3 <- ggplot(pc3, aes(y=coef, x=nmm)) + 
  geom_point(col = "red", size = 1) +
  geom_line(col = "red", lwd = .8) + 
  # geom_line(aes(y=coef-1.96*serr), col = 'darkred', linetype = 2) + 
  # geom_line(aes(y=coef+1.96*serr), col = 'darkred', linetype = 2) +
  geom_ribbon(aes(ymin = coef-1.64*serr, ymax = coef+1.64*serr), fill = "red", alpha=0.35) +
  scale_x_continuous(breaks = nmm[c(1, 5, 6, 7)], labels = nm[c(1, 5, 6, 7)]) +
  scale_y_continuous(labels=bsp(), limits = c(-0.5/100, 0.016), 
                     breaks = c(0,  .5,  1,  1.5 )/100) +
   xlab("") + ylab("") + 
  theme_minimal(base_size=9) + etheme + 
  geom_hline(yintercept=0, color='black', lty = 4)+
  ggtitle(snmf3pc) 

a1 <- arrangeGrob(release_footprint_1, ggplot() + theme_minimal(), ggplot() + theme_minimal(),  ncol = 3)
a2 <- arrangeGrob(conference_footprint_1, conference_footprint_2, conference_footprint_3, ncol = 3)

ggsave(filename = paste0(code_path, "output_figure/Figure3.pdf"), 
       plot = ggdraw(arrangeGrob(a1, a2, nrow = 2, ncol = 1)),
       width = 8,
       height = 6,
       device = "pdf")

