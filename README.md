# visium-crc-analysis

## Environment Setup

Space Ranger (download from https://www.10xgenomics.com/support/software/space-ranger/latest into ./lib/)
```bash
cd lib
tar -xzvf spaceranger-3.0.0.tar.gz
export PATH="/home/kirchmair/code/visium-crc-analysis/lib/spaceranger-3.0.0":$PATH
spaceranger sitecheck
spaceranger testrun --id=tiny
```

Conda
```bash
conda create -n 'visium-crc-analysis' -y
conda activate visium-crc-analysis
conda install python=3.9
conda install squidpy scvi-tools ipykernel python-igraph bih-cubi::bcl2fastq2
python -m ipykernel install --user --name visium-crc-analysis --display-name "visium-crc-analysis-kernel"
pip install spatialdata
pip install spatialdata-io
pip install spatialdata-plot
pip install napari-spatialdata
```

## Download Visium HD Data

```bash
mkdir data/input data/output

# Input Files
cd data/input
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_image.tif
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_tissue_image.btf
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_alignment_file.json
curl -O https://s3-us-west-2.amazonaws.com/10x.files/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_fastqs.tar
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_probe_set.csv
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_slide_file.vlf
cd ../..

# Output Files
cd data/output
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_web_summary.html
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_cloupe_008um.cloupe
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_feature_slice.h5
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_metrics_summary.csv
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_molecule_info.h5
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_spatial.tar.gz
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_square_002um_outputs.tar.gz
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_square_008um_outputs.tar.gz
curl -O https://cf.10xgenomics.com/samples/spatial-exp/3.0.0/Visium_HD_Human_Colon_Cancer/Visium_HD_Human_Colon_Cancer_square_016um_outputs.tar.gz

tar -xvf Visium_HD_Human_Colon_Cancer_fastqs.tar
tar -xzvf Visium_HD_Human_Colon_Cancer_spatial.tar.gz
tar -xzvf Visium_HD_Human_Colon_Cancer_square_002um_outputs.tar.gz
tar -xzvf Visium_HD_Human_Colon_Cancer_square_008um_outputs.tar.gz
tar -xzvf Visium_HD_Human_Colon_Cancer_square_016um_outputs.tar.gz
```


## Run Space Ranger
https://www.10xgenomics.com/support/software/space-ranger/latest/analysis/running-pipelines/count-visium-hd

'Local' mode on a cluster node:
```bash
cd data
sbatch ../lib/run_spaceranger.sh    'reprocessed' \
                                    'input/Visium_HD_Human_Colon_Cancer_fastqs' \
                                    'input/Visium_HD_Human_Colon_Cancer_image.tif' \
                                    'input/Visium_HD_Human_Colon_Cancer_slide_file.vlf' \
                                    'input/Visium_HD_Human_Colon_Cancer_probe_set.csv'
```

'Cluster' mode with Space Ranger handling job submission (requires slurm template):
```bash
cp lib/slurm.template lib/spaceranger-3.0.0/external/martian/jobmanagers/ # copy the template
spaceranger testrun --id=tiny --jobmode slurm
```

