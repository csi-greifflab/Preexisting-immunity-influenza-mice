# Alignment with UMI correction
java -Xmx128g -jar /storage/khangl/mixcr-4100/mixcr.jar align -f --library Mouse_BALBC_Ig_all_compiled --species mmu -p 10x-vdj-bcr -OvParameters.geneFeatureToAlign=VRegion --keep-non-CDR3-alignments --report alignmentReport.log  $(ls|grep R1)  $(ls|grep R2) alignments.vdjca

# Correction of the UMI sequence
java -Xmx128g -jar /storage/khangl/mixcr-4100/mixcr.jar refineTagsAndSort --report barcode.correction.report alignments.vdjca alignments.corrected.vdjca

# Partial assembly of CDR3 sequences
java -Xmx128g -jar /storage/khangl/mixcr-4100/mixcr.jar assemblePartial alignments.corrected.vdjca alignments.recovered.vdjca

#Assemble clonotypes by CDR3 region and C gene
java -Xmx128g -jar /storage/khangl/mixcr-4100/mixcr.jar assemble -f -Passembler.minRecordsPerConsensus=1 --report assembleReport.log alignments.recovered.vdjca clones.clna

# Assemble longest possible contigs
java -Xmx128g -jar /storage/khangl/mixcr-4100/mixcr.jar assembleContigs clones.clna clones.clns

# Export clonotypes
#java -Xmx64g -jar /storage/khangl/mixcr-4100/mixcr.jar exportClones -f --filter-out-of-frames --filter-stops  --dont-split-files  --split-by-tag cell\
#-cellGroup -uniqueTagCount cell -vGene -dGene -jGene -cGene -chains -nFeature VDJRegion -aaFeature VDJRegion -aaFeatureImputed VDJRegion \
#clones.clns clones.tsv

# Export contigs(to get individual cell barcodes)
java -Xmx128g -jar /storage/khangl/mixcr-4100/mixcr.jar exportClones -f --filter-out-of-frames --filter-stops  --dont-split-files \
-vGene -dGene -jGene -cGene -chains -nMutations FR1 -nMutations CDR1 -nMutations FR2 -nMutations CDR2 -nMutations FR3 -nMutations FR4 -nFeature VDJRegion -aaFeature VDJRegion -aaFeatureImputed VDJRegion \
clones.clns contigs.tsv

# Rename the clonotype table to the current folder name
#mv clones.tsv "$(basename "$(pwd)")"".txt"
mv contigs.tsv "$(basename "$(pwd)")""_contigs"".txt"
