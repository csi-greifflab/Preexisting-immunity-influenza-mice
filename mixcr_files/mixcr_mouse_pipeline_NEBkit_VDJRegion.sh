# Alignment with UMI correction
java -Xmx64g -jar /storage/khangl/mixcr-4100/mixcr.jar align -f --verbose --library Mouse_BALBC_Ig_all_compiled -p nebnext-mouse-bcr-full-length --tag-pattern "^(R1:*)\^(UMI:N{17})(R2:*)" -OvParameters.geneFeatureToAlign=VRegion --report alignmentReport.log $(ls|grep R1)  $(ls|grep R2) alignments.vdjca

# Error correction on the UMI sequences
java -Xmx64g -jar /storage/khangl/mixcr-4100/mixcr.jar refineTagsAndSort --report barcode.correction.report alignments.vdjca alignments.corrected.vdjca

#Assemble clonotypes by VDJ region and C gene

java -Xmx64g -jar /storage/khangl/mixcr-4100/mixcr.jar assemble -f -Passembler.minRecordsPerConsensus=1 -OassemblingFeatures="[VDJRegion]" -OaddReadsCountOnClustering=TRUE -OcloneClusteringParameters.clusteringFilter.specificMutationProbability=1E-4 -OseparateByV=true -OseparateByJ=true -OseparateByC=true --report assembleReport.log alignments.corrected.vdjca clones.clns

#Export clonotypes

#java -Xmx64g -jar /storage/khangl/mixcr-4100/mixcr.jar exportClones --filter-out-of-frames --filter-stops \
-aaMutations VRegion -aaMutations DRegion -aaMutations JRegion -vGene -dGene -jGene -cGene -chains -nFeature VDJRegion -aaFeature VDJRegion -aaFeatureImputed VDJRegion \
clones.clns clones.tsv

java -Xmx64g -jar /storage/khangl/mixcr-4100/mixcr.jar exportClones --filter-out-of-frames --filter-stops  --dont-split-files \
-vGene -dGene -jGene -cGene -chains -nFeature VDJRegion -aaFeature VDJRegion -aaFeatureImputed VDJRegion \
clones.clns clones.tsv

# Rename the clonotype table to the current folder name
mv clones.tsv "$(basename "$(pwd)")"".txt"