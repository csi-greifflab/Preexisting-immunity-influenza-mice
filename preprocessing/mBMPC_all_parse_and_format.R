library(immunarch)
library(tidyverse)

#Load the data in immunarch
data_rep1 <- repLoad("./2_Ig_all_filtered_rep1/", .coding = FALSE)
data_rep2 <- repLoad("./2_Ig_all_filtered_rep2/", .coding = FALSE)
data_rep3 <- repLoad("./2_Ig_all_filtered_rep3/", .coding = FALSE)


# Load the data from the source mixcr files
path_rep1 <- list.files("./2_Ig_all_filtered_rep1/", full.names = T)
path_rep2 <- list.files("./2_Ig_all_filtered_rep2/", full.names = T)
path_rep3 <- list.files("./2_Ig_all_filtered_rep3/", full.names = T)

mixcr_rep1 <- lapply(path_rep1, function (x) fread(x))
mixcr_rep2 <- lapply(path_rep2, function (x) fread(x))
mixcr_rep3 <- lapply(path_rep3, function (x) fread(x))

names(mixcr_rep1) <- str_split(list.files("./2_Ig_all_filtered_rep1/"), "\\.", simplify = T)[,1]
names(mixcr_rep2) <- str_split(list.files("./2_Ig_all_filtered_rep2/"), "\\.", simplify = T)[,1]
names(mixcr_rep3) <- str_split(list.files("./2_Ig_all_filtered_rep3/"), "\\.", simplify = T)[,1]


# Replace the clonal count in immunarch with the unique UMI count in mixcr, gene name without score, and imputed VDJ seq (for future cloning)
for (i in 1:length(data_rep1$data)){
  data_rep1$data[[i]]$Clones <- mixcr_rep1[[i]]$uniqueUMICount
  data_rep1$data[[i]]$Proportion <- data_rep1$data[[i]]$Clones/sum(data_rep1$data[[i]]$Clones)
  data_rep1$data[[i]]$V.name <- mixcr_rep1[[i]]$bestVGene
  data_rep1$data[[i]]$D.name <- mixcr_rep1[[i]]$bestDGene
  data_rep1$data[[i]]$J.name <- mixcr_rep1[[i]]$bestJGene
  data_rep1$data[[i]]$C.name <- mixcr_rep1[[i]]$bestCGene
  data_rep1$data[[i]]$Sequence.aa <- mixcr_rep1[[i]]$aaSeqVDJRegion
  data_rep1$data[[i]]$Sequence.aa.imputed <- mixcr_rep1[[i]]$aaSeqImputedVDJRegion
}

for (i in 1:length(data_rep2$data)){
  data_rep2$data[[i]]$Clones <- mixcr_rep2[[i]]$uniqueUMICount
  data_rep2$data[[i]]$Proportion <- data_rep2$data[[i]]$Clones/sum(data_rep2$data[[i]]$Clones)
  data_rep2$data[[i]]$V.name <- mixcr_rep2[[i]]$bestVGene
  data_rep2$data[[i]]$D.name <- mixcr_rep2[[i]]$bestDGene
  data_rep2$data[[i]]$J.name <- mixcr_rep2[[i]]$bestJGene
  data_rep2$data[[i]]$C.name <- mixcr_rep2[[i]]$bestCGene
  data_rep2$data[[i]]$Sequence.aa <- mixcr_rep2[[i]]$aaSeqVDJRegion
  data_rep2$data[[i]]$Sequence.aa.imputed <- mixcr_rep2[[i]]$aaSeqImputedVDJRegion
}

for (i in 1:length(data_rep3$data)){
  data_rep3$data[[i]]$Clones <- mixcr_rep3[[i]]$uniqueUMICount
  data_rep3$data[[i]]$Proportion <- data_rep3$data[[i]]$Clones/sum(data_rep3$data[[i]]$Clones)
  data_rep3$data[[i]]$V.name <- mixcr_rep3[[i]]$bestVGene
  data_rep3$data[[i]]$D.name <- mixcr_rep3[[i]]$bestDGene
  data_rep3$data[[i]]$J.name <- mixcr_rep3[[i]]$bestJGene
  data_rep3$data[[i]]$C.name <- mixcr_rep3[[i]]$bestCGene
  data_rep3$data[[i]]$Sequence.aa <- mixcr_rep3[[i]]$aaSeqVDJRegion
  data_rep3$data[[i]]$Sequence.aa.imputed <- mixcr_rep3[[i]]$aaSeqImputedVDJRegion
}

# Split the dataset into heavy and light chains
data_rep1_hc <- lapply(data_rep1$data, function (x) x[str_which(x$C.name, "^IGH"),])
data_rep2_hc <- lapply(data_rep2$data, function (x) x[str_which(x$C.name, "^IGH"),])
data_rep3_hc <- lapply(data_rep3$data, function (x) x[str_which(x$C.name, "^IGH"),])

names(data_rep1_hc) <- paste0(names(data_rep1_hc),"_1_hc")
names(data_rep2_hc) <- paste0(names(data_rep2_hc),"_2_hc")
names(data_rep3_hc) <- paste0(names(data_rep3_hc),"_3_hc")

data_rep1_lc <- lapply(data_rep1$data, function (x) x[-str_which(x$C.name, "^IGH"),])
data_rep2_lc <- lapply(data_rep2$data, function (x) x[-str_which(x$C.name, "^IGH"),])
data_rep3_lc <- lapply(data_rep3$data, function (x) x[-str_which(x$C.name, "^IGH"),])

names(data_rep1_lc) <- paste0(names(data_rep1_lc),"_1_lc")
names(data_rep2_lc) <- paste0(names(data_rep2_lc),"_2_lc")
names(data_rep3_lc) <- paste0(names(data_rep3_lc),"_3_lc")


data_all$data <- c(data_rep1_hc, data_rep1_lc, data_rep2_hc, data_rep2_lc, data_rep3_hc, data_rep3_lc)

# Setup the metadata df
data_all$meta <- data_frame(Sample = names(data_all$data),
                            Sample_Number = str_split(names(data_all$data), "_", simplify = T)[,2],
                            Replicate = str_split(names(data_all$data), "_", simplify = T)[,3])
  
number_vec <- as.numeric(data_all$meta$Sample_Number) # Store the sample number as numeric for conditions

data_all$meta$Infection_1 <- case_when(number_vec >= 1 & number_vec <= 16 ~ "PBS",
          number_vec >= 17 & number_vec <= 24 ~ "H1N1_CA07",
          number_vec >= 25 & number_vec <= 32 ~ "H1N1_PR08")

data_all$meta$Infection_2 <- case_when(number_vec >= 1 & number_vec <= 8 ~ "PBS",
                                       number_vec >= 9 & number_vec <= 32 ~ "H1N1_CA07")

data_all$meta$Infections <- paste(data_all$meta$Infection_1, data_all$meta$Infection_2, sep = ";")

# Recalculate the clonal proportion after splitting into heavy and light chain
for (i in 1:length(data_all$data)){
  data_all$data[[i]]$Proportion <- data_all$data[[i]]$Clones/sum(data_all$data[[i]]$Clones)
}
  
saveRDS(data_all, "./data_rep_all")
