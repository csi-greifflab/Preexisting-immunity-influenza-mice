# Preexisting immunity in influenza mice

Code and processed data for:

> **Influenza H1N1 Imprinting Uncouples Serological and B-Cell Responses in Mice**
> Elias Tjärnhage, Khang Lê Quý, Taissa de Matos Kasahara, Marit Lovise Toven Dæhli, Victor Greiff, Gunnveig Grødeland
> Institute of Clinical Medicine, University of Oslo, Oslo, Norway

## About the study

Seasonal influenza viruses continuously acquire antigenic drift, but new infections/vaccinations often preferentially recall antibodies targeting previously encountered strains — a phenomenon known as **immunological imprinting** ("original antigenic sin"). Most of our understanding of imprinting is based on serology alone; its cellular basis is poorly understood.

Here, BALB/c mice were sequentially challenged (6 weeks apart) with two antigenically distinct H1N1 strains — the 2009 pandemic strain A/California/07/2009 (**CA07**) and the mouse-adapted strain A/Puerto Rico/8/1934 (**PR8**) — and immune responses were profiled at both the serological and cellular level:

- Serum IgG, competition ELISA, microneutralization, and adoptive serum transfer
- Flow cytometry of germinal center (GC) and memory B cell subsets (PD-L2/CD80)
- **Single-cell BCR sequencing** (gene expression + V(D)J + surface protein/CITE-seq, with hashtag and HA-dCODE demultiplexing) of HA-specific lymph node B cells
- **Bulk BCR sequencing** of bone marrow plasma cells (CD138+)
- CDRH3 repertoire/network analyses and recombinant mAb validation of sc-derived clonotypes

**Main finding:** Priming with CA07 largely prevented new serum antibody responses upon PR8 re-infection, whereas PR8 priming updated the serum specificity towards the last virus. Strikingly, this serological imprinting was *not* mirrored at the B-cell level — GC B cells generated diverse, updated BCR repertoires against the heterologous strain without conserved CDRH3 motifs. Cellular and serological responses are thus uncoupled during influenza imprinting, and both compartments must be studied to understand immune memory and improve seasonal vaccines.

## Repository structure

```
├── cellranger_out/     10x Cell Ranger count output per sequencing run (E48, E50, E51, E70),
│                       stored as .tar.xz archives (<100 MB each); see how_to_unzip.txt
├── preprocessing/
│   ├── mBMPC_all_parse_and_format.R       Parse bulk MiXCR clonotype tables into immunarch format
│   ├── mBMPC_Bulkseq_all.Rmd              Bulk BCR-seq repertoire analysis of bone marrow plasma cells
│   ├── Scseq_preprocessing_E48-50-51.Rmd  Single-cell BCR-seq preprocessing (contig filtering,
│   │                                       hashtag/HTO demultiplexing merge, formatting)
│   └── Scseq_preprocessing_E70.Rmd        Same for run E70
├── data_analysis/
│   ├── Sc_GEX_E48.rmd ... Sc_GEX_E70.rmd  Per-run single-cell gene expression analysis in Seurat:
│   │                                       ambient RNA removal (SoupX), doublet detection
│   │                                       (DoubletFinder), hashtag demultiplexing (HTOdemux),
│   │                                       SCTransform, clustering, HA (CA07/PR8/OVA dCODE)
│   │                                       specificity assignment, BCR integration (scRepertoire),
│   │                                       and somatic hypermutation analysis
│   ├── network_analysis.Rmd               CDR3 amino-acid sequence-similarity networks
│   │                                       (Levenshtein distance ≤ 1, igraph + ForceAtlas2)
│   └── bulkseq_scseq_comparison.Rmd       Overlap/comparison of bulk plasma-cell and
│                                           single-cell lymph-node BCR repertoires
├── mixcr_files/        MiXCR v4.1.0 pipeline scripts (bulk 5'RACE NEBNext and 10x VDJ presets) and a
│                       custom BALB/c germline gene library compiled with repseqio from OGRDB/IMGT
├── annotations/        Hashtag (HTO) demultiplexing tables, HA specificity assignments, and
│                       OGRDB/IMGT germline gene reference tables
└── misc/               data_all_both.xz — combined processed repertoire object (RDS, ~1.3 GB
                        decompressed; read in R with readRDS(xzfile("data_all_both.xz")))
```

**Note:** Scripts contain absolute file paths from the original workstations — update the paths at the top of each script to point to your local copy of the data before running.

## Requirements

### Non-R dependencies

- **R** (≥ 4.1) and **RStudio** (recommended, to knit the R Markdown files)
- **MiXCR v4.1.0** (with Java) — used with the custom BALB/c library in `mixcr_files/`
- **Cell Ranger** (10x Genomics) — only needed if re-processing raw FASTQs; processed outputs are provided in `cellranger_out/`

### R packages

Install from CRAN (plus Bioconductor/GitHub where noted):

```r
# CRAN
install.packages(c(
  "tidyverse", "dplyr", "ggplot2", "reshape2", "scales", "RColorBrewer",
  "cowplot", "ggplotify", "patchwork", "svglite", "viridis", "grid",
  "Seurat", "sctransform", "future", "clustree", "scCustomize", "circlize",
  "ggraph", "igraph", "stringdist", "stringi", "vegan", "pheatmap", "seqinr",
  "GGally", "ggpubr", "ggbeeswarm", "rstatix", "cluster", "data.table",
  "magick", "webr", "KernSmooth",
  "immunarch", "Platypus", "scRepertoire"
))

# Bioconductor
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("DropletUtils")

# GitHub
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
remotes::install_github("chris-mcginnis-ucsf/DoubletFinder")  # doublet detection
remotes::install_github("constantAmateur/SoupX")             # ambient RNA correction
remotes::install_github("sinabakh/ForceAtlas2")               # network layouts
remotes::install_github("immcantation/alakazam")               # BCR sequence analysis
remotes::install_github("immcantation/shazam")                # SHM analysis
```

## Data

Processed 10x Cell Ranger outputs (feature-barcode matrices) are provided per sequencing run as `.tar.xz` archives in `cellranger_out/` (each < 100 MB; see `cellranger_out/how_to_unzip.txt` — note that `matrix.mtx` is stored uncompressed inside the archives to meet the file size limit).

The complete processed repertoire object used in the final analyses is `misc/data_all_both.xz`:

```r
data_all <- readRDS(xzfile("misc/data_all_both.xz"))
```

Raw FASTQ files and flow cytometry data are deposited in public repositories (see the manuscript's Data availability section).

## Citation

If you use this code or data, please cite the manuscript:

Tjärnhage E, Lê Quý K, de Matos Kasahara T, Dæhli MLT, Greiff V, Grødeland G.
*Influenza H1N1 Imprinting Uncouples Serological and B-Cell Responses in Mice.*

## Contact

For questions, please open a GitHub issue or contact the corresponding authors of the manuscript.
