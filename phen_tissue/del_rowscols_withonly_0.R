setwd("~/BI/BRB1")
fgsea.res <- read.csv(file = "phens_by_tissues_1_0.tsv", header = TRUE, sep = "\t")
a <- fgsea.res[apply(fgsea.res[,-1], 1, function(x) !all(x==0)),]
a <- a[,apply(a, 2, function(x) !all(x==0))]

write.table(a, file = "phens_by_tissues_1_without_0.tsv" ,row.names = FALSE, dec = ".", sep = "\t", quote = FALSE)
