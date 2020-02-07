setwd("~/BI/BRB1")
df <- read.csv(file = "phens_by_tissues_1_without_0.tsv", header = TRUE, sep = "\t")
  df$phen <- gsub("_raw", "", df$phen)
df$phen <- gsub(".gwas.imputed_v3.both_sexes_temp", "", df$phen)
df$phen <- gsub(".gwas.imputed_v3.both_sexes.v2_temp", "", df$phen)
df$phen <- gsub(".gwas.imputed_v3.male_temp", "", df$phen)
df$phen <- gsub(".gwas.imputed_v3.female_temp", "", df$phen)

descr <- read.csv(file = "UKBB_GWAS_Imputed_v3_Rel_20180731_Descr.tsv", header = FALSE, sep = "\t")
colnames(descr) <-c("phen", "description")
descr$phen <- as.character(descr$phen)
descr$description <- as.character(descr$d)
descr$phen <- gsub("_raw", "", descr$phen)
descr$phen <- gsub("_irnt", "", descr$phen)
descr <- unique(descr)

for (i in c(1: length(df$phen))){
  df$phen[i] <- descr$description[descr$phen == df$phen[i]][1]
}

write.table(df, file = "phensnames_by_tissues_1_without_0.tsv" ,row.names = FALSE, dec = ".", sep = "\t", quote = FALSE)
