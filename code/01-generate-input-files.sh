#!/bin/bash

# This script runs MWAS in unadjusted vs adjusted methylation AUS and NL methylation datasets 

###########################
## Set working directory ##
###########################

wd=/gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/data/input_files

#################################
## Change to working directory ##
#################################

cd $wd

#########################
## path to OSCA binary ##
#########################

osca=/gpfs/gpfs01/polaris/Q0286/BRAIN-MEND/2019_AUS_ALS_PCTG_DNAm/software/osca

#####################################################
## Export methylation values in OSCA binary format ##
#####################################################

# The Australian/Netherlands unadjusted ALS datasets

export betas_aus="AUS_ALS_PCTG_qced_normalized_DNAm"
export betas_nl="Netherlands_ALS_qced_normalized_DNAm"

# The Australian/Netherlands adjuted ALS datasets

export betas_aus_adj="AUS_ALS_PCTG_qced_normalized_DNAm_autosomes_adjusted"
export betas_nl_adj="Netherlands_ALS_qced_normalized_autosomes_adjusted"


###############################################################################################################
## 450K Illumina probes to be masked because they cross-hybridizing and contain potentially problematic SNPs ##
## Following recommendation from :https://academic.oup.com/nar/article/45/4/e22/2290930                      ##
###############################################################################################################

# 450K Illumina probes linking to sex chromosomes and probes to be masked

export sex="sex_linked_probes_450K.txt"
export masking="hm450k_masking_probes_Zhou_et_al_2017.txt"

# I have some large temporary files that I don't want to keep so I create a temporary directory

# the directory's name

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# the temp directory used, within $DIR
# omit the -p parameter to create a temporal directory in the default location
WORK_DIR=`mktemp -d -p "$DIR"`

# check if tmp dir was created
if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

# deletes the temp directory
function cleanup {
  rm -rf "$WORK_DIR"
  echo "Deleted temp working directory $WORK_DIR"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

$osca --befile $betas_aus --exclude-probe $sex --make-bod --out ${WORK_DIR}/${betas_aus}_sex

$osca --befile $betas_nl --exclude-probe $sex --make-bod --out ${WORK_DIR}/${betas_nl}_sex


# Don't need to exclude sex chromosomes in the adjusted files, because we only adjust probes in autosomes

$osca --befile ${WORK_DIR}/${betas_aus}_sex --exclude-probe $masking --make-bod --out ${WORK_DIR}/${betas_aus}_masking

$osca --befile ${WORK_DIR}/${betas_nl}_sex --exclude-probe $masking --make-bod --out ${WORK_DIR}/${betas_nl}_masking

$osca --befile $betas_aus_adj --exclude-probe $masking --make-bod --out ${WORK_DIR}/${betas_aus_adj}_masking

$osca --befile $betas_nl_adj --exclude-probe $masking --make-bod --out ${WORK_DIR}/${betas_nl_adj}_masking

##################################
## Remove probes with SD < 0.02 ##
##################################

$osca --befile ${WORK_DIR}/${betas_aus}_masking --sd-min 0.02 --make-bod --out ${betas_aus}-autosomes-no-xreact-no-SNP-sd0.02

$osca --befile ${WORK_DIR}/${betas_nl}_masking --sd-min 0.02 --make-bod --out ${betas_nl}-autosomes-no-xreact-no-SNP-sd0.02

$osca --befile ${WORK_DIR}/${betas_aus_adj}_masking --sd-min 0.02 --make-bod --out ${betas_aus_adj}-no-xreact-no-SNP-sd0.02

$osca --befile ${WORK_DIR}/${betas_nl_adj}_masking --sd-min 0.02 --make-bod --out ${betas_nl_adj}-no-xreact-no-SNP-sd0.02


#####################
### Calculate ORM ###

$osca --befile ${betas_aus}-autosomes-no-xreact-no-SNP-sd0.02  --make-orm --orm-alg 1 --out ${betas_aus}-autosomes-no-xreact-no-SNP-sd0.02 

$osca --befile  ${betas_aus_adj}-no-xreact-no-SNP-sd0.02 --make-orm --orm-alg 1 --out  ${betas_aus_adj}-no-xreact-no-SNP-sd0.02

$osca --befile  ${betas_nl}-autosomes-no-xreact-no-SNP-sd0.02 --make-orm --orm-alg 1 --out  ${betas_nl}-autosomes-no-xreact-no-SNP-sd0.02  

$osca --befile  ${betas_nl_adj}-no-xreact-no-SNP-sd0.02 --make-orm --orm-alg 1 --out  ${betas_nl_adj}-no-xreact-no-SNP-sd0.02
