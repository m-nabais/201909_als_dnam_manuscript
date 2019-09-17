#!/bin/bash
# This script runs MPS predictions in adjusted methylation AUS, as discovery, and NL methylation dataset, as target


###########################
## Set working directory ##
###########################

wd=/gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/results/MWAS

#################################
## Change to working directory ##
#################################

cd $wd

#########################
## path to OSCA binary ##
#########################

osca=/gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/software/osca


##############################
## Export AUS MWAS results ##
#############################

[ ! -d "../MPS" ] && mkdir -p "../MPS"

# The Australian MWAS results

export lin_no_covs="AUS_ALS_PCTG_qced_normalized_DNAm_autosomes_adjusted-no-xreact-no-SNP-sd0.02-noCOVS.linear"
export lin_with_covs="AUS_ALS_PCTG_qced_normalized_DNAm_autosomes_adjusted-no-xreact-no-SNP-sd0.02-with-10PCS.linear"
export moa="AUS_ALS_PCTG_qced_normalized_DNAm_autosomes_adjusted-no-xreact-no-SNP-sd0.02-MOA.moa"
export mom="AUS_ALS_PCTG_qced_normalized_DNAm_autosomes_adjusted-no-xreact-no-SNP-sd0.02-MOMENT.moment"

# Export phenotype & methylation files
export betas_nl_adj="/gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/data/input_files/Netherlands_ALS_qced_normalized_autosomes_adjusted"

# Export directory to where results will be saved

dir="/gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/results/MPS/"

#########################################################
## Export the effect sizes based on p-value threshold ##
########################################################


Rscript /gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/code/generate_p-threshold.R $lin_no_covs $dir 

Rscript /gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/code/generate_p-threshold.R $lin_with_covs $dir 

Rscript /gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/code/generate_p-threshold.R $moa $dir 

Rscript /gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/code/generate_p-threshold.R $mom $dir 

#########################################################
## Calculate MPS for NL based on p-value thresholds   ##
########################################################

for f in /gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/results/MPS/*.blp ; do $osca --befile $betas_nl_adj --score $f --out ${f} ; done

##################################################
## Rearrange files in different directories    ##
#################################################

[ ! -d "../MPS/linear_NOCOVS" ] && mkdir -p "../MPS/linear_NOCOVS"

[ ! -d "../MPS/linear_WITH-COVS" ] && mkdir -p "../MPS/linear_WITH-COVS"

[ ! -d "../MPS/MOA" ] && mkdir -p "../MPS/MOA"

[ ! -d "../MPS/MOMENT" ] && mkdir -p "../MPS/MOMENT"

cd ../MPS

mv ${lin_no_covs}*.profile linear_NOCOVS

mv ${lin_with_covs}*.profile linear_WITH-COVS

mv ${moa}*.profile MOA

mv ${mom}*.profile MOMENT 


