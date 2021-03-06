
#this script creates the physiology  based data table for the mauscripts
library(doBy)
source("functions and packages/functions.R")
source("functions and packages/plot objects.R")
       
###variabvles:  Amax, Rd, Jmax, VCmax, gs, g1
  
#1:Amax
A_means <- read.csv("calculated data/A_treatment_means.csv")
  A_means$volume <- as.numeric(c("5", "10", "15", "20", "25", "35", "1000"))

table2 <- A_means[, 1:3]

#2: Rd
rd <- read.csv("calculated data/Rd_leaf.csv")
rd_agg <- summaryBy(resppermass ~ volume, data=rd, FUN=c(mean, se))
  rd_agg$resppermass.mean <- abs(rd_agg$resppermass.mean)

table2 <- merge(table2, rd_agg)
       
       
##2-3: jmax, vcmax
phys <- read.csv("calculated data/jmax_vcmax.csv")

  phys_agg <- summaryBy(Jmax.mean+Vcmax.mean ~ volume, data=phys, FUN=c(mean, se))
  names(phys_agg)[2:5]<- c("Jmax", "Vcmax", "Jmax_se", "Vcmax_se")

table2 <- merge(table2, phys_agg)
       
#4. gs
gs <- read.csv("calculated data/conductance.csv")

  gs_agg <- summaryBy(gs ~ volume, data=gs, FUN=c(mean, se))

table2 <- merge(table2, gs_agg)

#5. g1 (uses mean of g1 date)
g1 <- read.csv("calculated data/g1_pred.csv")
  
  g1_agg <- summaryBy(g1_date ~ volume, data=g1, FUN=c(mean, se))
  names(g1_agg)[2:3]<- c("g1", "g1_se")

table2 <- merge(table2, g1_agg)


###now sort the table into correct var + se--------------------------------------------------------------------
phys_tab <-table2[,c(1,2,3,4,5,6,8,7,9,10,11,12,13)]


#seperate dfr in two with mean and se, omit volume for now
phys_means <- phys_tab[, c(2,4,6,8,10,12)]
phys_se <- phys_tab[, c(3,5,7,9,11,13)]

###now paste together and round
phys1 <- data.frame(paste0(sprintf("%2.1f", round(phys_means[,1], 1)), " (", sprintf("%2.1f", round(phys_se[,1],1)),")"))
phys2 <- data.frame(paste0(sprintf("%2.1f", round(phys_means[,2], 1)), " (", sprintf("%2.1f", round(phys_se[,2],1)),")"))
phys3 <- data.frame(paste0(sprintf("%2.1f", round(phys_means[,3], 1)), " (", sprintf("%2.1f", round(phys_se[,3],1)),")"))
phys4 <- data.frame(paste0(sprintf("%2.1f", round(phys_means[,4], 1)), " (", sprintf("%2.1f", round(phys_se[,4],1)),")"))
phys5 <- data.frame(paste0(sprintf("%3.2f",round(phys_means[,5], 2)), " (", round(phys_se[,5],2),")"))
phys6 <- data.frame(paste0(sprintf("%2.1f",round(phys_means[,6], 1)), " (", sprintf("%2.1f",round(phys_se[,6],1)),")"))


pve_table2 <- cbind(leglab, phys1)
  pve_table2 <- cbind(pve_table2, phys2)
  pve_table2 <- cbind(pve_table2, phys3)
  pve_table2 <- cbind(pve_table2, phys4)
  pve_table2 <- cbind(pve_table2, phys5)
  pve_table2 <- cbind(pve_table2, phys6)

write.csv(pve_table2, "master_scripts/pve_table2.csv", row.names=FALSE)




