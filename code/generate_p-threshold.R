#!/usr/bin/env Rscript

file <- commandArgs(trailingOnly=TRUE)

mwas <- read.table(file[1], header=TRUE, sep ="\t")

write.table(mwas[mwas$p<0.05/nrow(mwas),c("Probe", "b")], paste(file[2],file[1], "_bonferroni_probe.blp", sep=""), quote=F, sep="\t", row.names=F, col.names=F)

write.table(mwas[mwas$p<1e-05,c("Probe", "b")], paste(file[2],file[1], "_1e-05_probe.blp", sep=""), quote=F, sep="\t", row.names=F, col.names=F)

write.table(mwas[mwas$p<1e-04,c("Probe", "b")],paste(file[2],file[1], "_1e-04_probe.blp", sep=""), quote=F, sep="\t", row.names=F, col.names=F)

write.table(mwas[mwas$p<1e-03,c("Probe", "b")], paste(file[2],file[1], "_1e-03_probe.blp", sep=""), quote=F, sep="\t", row.names=F, col.names=F)

write.table(mwas[mwas$p<1e-02,c("Probe", "b")], paste(file[2],file[1], "_1e-02_probe.blp", sep=""), quote=F, sep="\t", row.names=F, col.names=F)

write.table(mwas[mwas$p<0.1,c("Probe", "b")], paste(file[2],file[1], "_0.1_probe.blp", sep=""), quote=F, sep="\t", row.names=F, col.names=F)

write.table(mwas[mwas$p<0.2,c("Probe", "b")], paste(file[2],file[1], "_0.2_probe.blp", sep=""), quote=F, sep="\t", row.names=F, col.names=F)

write.table(mwas[mwas$p<0.5,c("Probe", "b")], paste(file[2],file[1], "_0.3_probe.blp", sep=""), quote=F, sep="\t", row.names=F, col.names=F)
