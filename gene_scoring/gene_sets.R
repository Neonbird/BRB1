# Here are summarised data from enrichment analyzes for all gene scoring methods.
# Enrichment analysis was carried out for top 100, 50, 25 and 10 phenotype-associated genes
# Phenotipes: Thrombosis, Asthma
# The resulst are shown in plots

library(ggplot2)
library(RColorBrewer)

gene_sets_thromb <- data.frame(c("Pascal", "Pascal", "Pascal", "Pascal",
                            "Sqrt", "Sqrt", "Sqrt", "Sqrt", "Abs", "Abs", "Abs", "Abs",
                            "Min_pvalue", "Min_pvalue", "Min_pvalue", "Min_pvalue",
                            "Second_min", "Second_min", "Second_min", "Second_min"),
                          c(100, 50, 25, 10, 100, 50, 25, 10, 100, 50, 25, 10,
                            100, 50, 25, 10, 100, 50, 25, 10 ),
                          c(92, 100, 100, 11, 7, 2, 2, 0, 8, 3, 1, 1, 100, 76, 4, 1, 100, 6, 5, 1))
colnames(gene_sets_thromb) <- c("Method", "Top_n", "Gene_sets")

gene_sets_asthma <- data.frame(c("Pascal", "Pascal", "Pascal", "Pascal",
                                 "Sqrt", "Sqrt", "Sqrt", "Sqrt", "Abs", "Abs", "Abs", "Abs",
                                 "Not_abs", "Not_abs", "Not_abs", "Not_abs",
                                 "Min_pvalue", "Min_pvalue", "Min_pvalue", "Min_pvalue",
                                 "Second_min", "Second_min", "Second_min", "Second_min"),
                               c(100, 50, 25, 10, 100, 50, 25, 10, 100, 50, 25, 10, 100, 50, 25, 10,
                                 100, 50, 25, 10, 100, 50, 25, 10 ),
                               c(100, 100, 100, 9, 4, 3, 4, 1, 9, 7, 7, 1, 3, 4, 1, 1, 79, 6, 5, 2, 10, 6, 7, 1))
colnames(gene_sets_asthma) <- c("Method", "Top_n", "Gene_sets")

# Plot for Thrombosis phenotype

ggplot(gene_sets_thromb, aes(Top_n, Gene_sets, color = Method))+
  geom_point()+
  geom_line()+
  ggtitle("Phenotype: Thrombosis")+
  scale_color_discrete(name="Method")+
  xlab("Number of genes")+
  ylab("Number of genesets")+
  theme(text = element_text(size=14))

# Plot for Asthma phenotype

ggplot(gene_sets_asthma, aes(Top_n, Gene_sets, color=Method))+
  geom_point()+
  geom_line()+
  ggtitle("Phenotype: Asthma")+
  scale_color_discrete(name="Method")+
  xlab("Number of genes")+
  ylab("Number of genesets")+
  theme(text = element_text(size=14))



  