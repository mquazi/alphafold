#!/bin/bash
#SBATCH --job-name alphaexample
#SBATCH --time=08:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=85G
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --mail-user=mquazi@unm.edu 
#SBATCH --partition=tid
#SBATCH --output alphaexample.out
#SBATCH --error alphaexample2.err

# Load required module
module load singularity

# Specify input/output paths
# gper1.fasta is the only input file 
SINGULARITY_IMAGE_PATH=/carc/scratch/projects/toprea2016222/alphafold_xena_2.1.1/
ALPHAFOLD_DATA_PATH=/carc/scratch/shared/alphafold/data
ALPHAFOLD_MODELS=$ALPHAFOLD_DATA_PATH/params

# Change to the directory where the PBS script was submitted from
cd $SLURM_SUBMIT_DIR/


ALPHAFOLD_INPUT_FASTA=gper1.fasta
NOW=$(date +"%Y_%m_%d_%H_%M_%S")
ALPHAFOLD_OUTPUT_DIR=alphafold_output-$NOW

mkdir -p $ALPHAFOLD_OUTPUT_DIR

# Run the command
 singularity run --nv \
 --bind $ALPHAFOLD_DATA_PATH:/data \
 --bind $ALPHAFOLD_MODELS \
 --bind $ALPHAFOLD_OUTPUT_DIR:/alphafold_output \
 --bind $ALPHAFOLD_INPUT_FASTA:/input.fasta \
 --bind .:/etc \
 --pwd /app/alphafold $SINGULARITY_IMAGE_PATH/alphafold_2.1.1.sif \
 --fasta_paths=/input.fasta \
 --uniref90_database_path=/data/uniref90/uniref90.fasta \
 --data_dir=/data \
 --mgnify_database_path=/data/mgnify/mgy_clusters_2018_12.fa  \
 --bfd_database_path=/data/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt \
 --uniclust30_database_path=/data/uniclust30/uniclust30_2018_08/uniclust30_2018_08 \
 --pdb70_database_path=/data/pdb70/pdb70 \
 --template_mmcif_dir=/data/pdb_mmcif/mmcif_files \
--obsolete_pdbs_path=/data/pdb_mmcif/obsolete.dat \
 --max_template_date=2020-05-14  \
 --output_dir=/alphafold_output \
 --model_preset=monomer \
 #--preset=casp14
