list.of.packages <- c("data.table", "dplyr", "ggplot2", "tidyr", "BiocManager", "fgsea")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(data.table)
library(dplyr)
library(ggplot2)
library(fgsea)
library(tidyr)


args<-commandArgs(TRUE)
TPM_file <- args[1]
dir_with_gene_score_file <- args[2]
TPM_threshold <- as.numeric(args[3])

# setwd("~/BI/BRB1/")
# TPM_file <- "Python/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_median_tpm.gct"
# dir_with_gene_score_file <- "data/"
# gene_score_filename <- my.files[1]
# TPM_threshold <- 1

tissues_TPM <- read.table(TPM_file,
                          skip = 2, header = TRUE, sep = "\t")
tissues_TPM$Name <- NULL
#Проверка на то, у всех генов с одним названием уникальные значения
#dupl_Desc <- tissues_TPS[duplicated(tissues_TPS$Description),]
#length(unique(dupl_Desc)) == length(dupl_Desc)

#Соединить строки с неуникальными генами вместе
tissues_TPM <- tissues_TPM %>% group_by(Description) %>% summarise_all(list(sum))


my.files <- list.files(path = dir_with_gene_score_file, pattern = ".sum.genescores.txt")

for (gene_score_filename in my.files) {
  phen_gene_scores <- read.csv(file = paste(dir_with_gene_score_file, gene_score_filename,
                                            sep = ''), 
                               header = TRUE, sep = "\t")
  phen_gene_scores <- phen_gene_scores %>% select(gene_symbol, pvalue)
  
  #Создать объединённый датафрейм для генов со скорами и экспрессией по тканям
  gene_score_TPM <- inner_join(x = phen_gene_scores, y = tissues_TPM, 
                               by = c('gene_symbol' = 'Description'))
  
  
  # # Нормализовать гены по тканям
  # gene_score_TPM_zg <- gene_score_TPS
  # gene_score_TPM_zg[, 3:ncol(gene_score_TPM_zg)] <- t(apply(
  #   gene_score_TPS[, 3:ncol(gene_score_TPS)], 1, scale
  #   ))
  
  # Выбрать для ткани гены, которые в ней экспрессируются больше чем некоторое TPM
  broad_exp <- list()
  for (i in 3:ncol(gene_score_TPM)){
    tis <- colnames(gene_score_TPM)[i]
    best_exp <- subset(gene_score_TPM$gene_symbol, gene_score_TPM[[tis]] >= TPM_threshold)
    broad_exp[[i-2]] <- c(tis, 'NA', best_exp)
  }
  
  broad_exp <- t(data.frame(lapply(broad_exp, "length<-", max(lengths(broad_exp)))))
  broad_exp_df <- as.data.frame(t(broad_exp), row.names = c())
  colnames(broad_exp_df) <- as.matrix(broad_exp_df[1, ])
  broad_exp_df <- broad_exp_df[c(-1,-2), ]
  broad_exp_df[] <- lapply(broad_exp_df, function(x) as.character(x))
  
  ## Подготовка в fgsea
  ranks <- gene_score_TPM[, c(2,1)]
  ranks$pvalue <- -log10(ranks$pvalue)
  ranks <- setNames(ranks$pvalue, ranks$gene_symbol)
  ranks <- ranks[!is.na(ranks)]
  
  fgseaRes <- fgsea(pathways = broad_exp_df, 
                    stats = ranks,
                    minSize=15,
                    maxSize=1500,
                    nperm=10000)
  
  fgseaRes$leadingEdge <- unlist(lapply(fgseaRes$leadingEdge, function(x){paste(x, collapse = ', ')}))
  fgseaRes <- arrange(fgseaRes, padj)
  # plotEnrichment(diff_exp_df$Liver,ranks) + labs(title='Liver')
  
  # topPathwaysUp <- fgseaRes[ES > 0][head(order(pval), n=6), pathway]
  # topPathwaysDown <- fgseaRes[ES < 0][head(order  (pval), n=6), pathway]
  # topPathways <- c(topPathwaysUp, rev(topPathwaysDown))
  # plotGseaTable(diff_exp_df[topPathways], ranks, fgseaRes, 
  #               gseaParam = 0.5)
  
  write.table(fgseaRes, file = paste("fgseaRes_", TPM_threshold, "/", 
                                   gsub(".sum.genescores.txt", "", gene_score_filename) , 
                                   ".fgseaRes.TPM_", TPM_threshold, ".csv", sep = ''), 
            sep = ";")
}
