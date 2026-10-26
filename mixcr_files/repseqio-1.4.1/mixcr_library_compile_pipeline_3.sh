# Create library for V genes
java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 0 --chain IGH --gene-type V\
-PFR1Begin=0 -PCDR1Begin=78 -PFR2Begin=114 -PCDR2Begin=165 -PFR3Begin=195 -PCDR3Begin=309 -PVEnd=-1 \
Mouse_BALB_c_IGHV_rev_3_gapped.fasta OGR_BALBC_IGHV.json.fasta OGR_BALBC_IGHV.json

java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 0 --chain IGK --gene-type V --gene-feature VRegion \
Mouse_BALB_cByJ_IGKV_rev_1_gapped.fasta Mouse_BALB_cByJ_IGKV_rev_1.json.fasta Mouse_BALB_cByJ_IGKV_rev_1.json

java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 0 --chain IGL --gene-type V --gene-feature VRegion \
Mouse_BALB_c_ByJ_IGLV_rev_1_gapped.fasta Mouse_BALB_c_ByJ_IGLV_rev_1.json.fasta Mouse_BALB_c_ByJ_IGLV_rev_1.json

# Create library for D genes
java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 0 --chain IGH --gene-type D --gene-feature DRegion \
Mouse_BALB_c_IGHD_rev_3_gapped.fasta OGR_BALBC_IGHD.json.fasta OGR_BALBC_IGHD.json

# Create library for J genes
java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 0 --chain IGH --gene-type J\
-PJBegin=0 -PFR4Begin=-31 -LFR4Begin='[WF](G.G)' -PFR4End=-1 \
Mouse_BALB_c_IGHJ_rev_3_gapped.fasta OGR_BALBC_IGHJ.json.fasta OGR_BALBC_IGHJ.json

java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 0 --chain IGK --gene-type J --gene-feature JRegion \
Mouse_IGKJ_rev_1_gapped.fasta Mouse_IGKJ_rev_1.json.fasta Mouse_IGKJ_rev_1.json

java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 0 --chain IGL --gene-type J --gene-feature JRegion \
Mouse_IGLJ_rev_1_gapped.fasta Mouse_IGLJ_rev_1.json.fasta Mouse_IGLJ_rev_1.json

# Create library for C genes (find somewhere in IMGT)
java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 1 --chain IGH --gene-type C --gene-feature CExon1 Mouse_IMGT_IGHC_CH1_gapped.fasta Mouse_IMGT_IGHC_CH1.json.fasta Mouse_IMGT_IGHC_CH1.json
java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 1 --chain IGK --gene-type C --gene-feature CRegion Mouse_IMGT_IGKC_gapped.fasta Mouse_IMGT_IGKC.json.fasta Mouse_IMGT_IGKC.json
java -jar repseqio.jar fromPaddedFasta --taxon-id 10090 --species-name mmu --name-index 1 --chain IGL --gene-type C --gene-feature CRegion Mouse_IMGT_IGLC_gapped.fasta Mouse_IMGT_IGLC.json.fasta Mouse_IMGT_IGLC.json

# Infer CDR anchor points (using repsepio internal reference library)
java -jar repseqio.jar inferPoints -g VRegion -f Mouse_BALB_cByJ_IGKV_rev_1.json Mouse_BALB_cByJ_IGKV_rev_1.json
java -jar repseqio.jar inferPoints -g VRegion -f Mouse_BALB_c_ByJ_IGLV_rev_1.json Mouse_BALB_c_ByJ_IGLV_rev_1.json
java -jar repseqio.jar inferPoints -g JRegion -f Mouse_IGKJ_rev_1.json Mouse_IGKJ_rev_1.json
java -jar repseqio.jar inferPoints -g JRegion -f Mouse_IGLJ_rev_1.json Mouse_IGLJ_rev_1.json


# Merge the libraries
#java -jar repseqio.jar merge OGR_BALBC_IGHV.json OGR_BALBC_IGHD.json OGR_BALBC_IGHJ.json OGR_BALBC_IGH.json
java -jar repseqio.jar merge OGR_BALBC_IGHV.json OGR_BALBC_IGHD.json OGR_BALBC_IGHJ.json Mouse_IMGT_IGHC_CH1.json Mouse_BALB_cByJ_IGKV_rev_1.json Mouse_IGKJ_rev_1.json Mouse_IMGT_IGKC.json Mouse_BALB_c_ByJ_IGLV_rev_1.json Mouse_IGLJ_rev_1.json Mouse_IMGT_IGLC.json Mouse_BALBC_Ig_all.json

# Compile the library
#java -jar repseqio.jar compile -f OGR_BALBC_IGH.json OGR_BALBC_IGH_compiled.json
java -jar repseqio.jar compile -f Mouse_BALBC_Ig_all.json Mouse_BALBC_Ig_all_compiled.json

# Debug the library
#java -jar repseqio.jar debug OGR_BALBC_IGH_compiled.json > OGR_BALBC_IGH_compiled_debug.txt
java -jar repseqio.jar debug Mouse_BALBC_Ig_all_compiled.json > Mouse_BALBC_Ig_all_debug.txt