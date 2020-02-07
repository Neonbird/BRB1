args<-commandArgs(TRUE)
dir_with_fgseaRes <- args[1]

my.files <- list.files(path = dir_with_fgseaRes, pattern = ".fgseaRes.csv")

df <- data.frame(matrix(nrow = length(my.files), ncol = 55))
df[,1] <- my.files
colnames(df) <- c("phen", c("Adipose...Subcutaneous","Adipose...Visceral..Omentum.",
                            "Adrenal.Gland","Artery...Aorta","Artery...Coronary",
                            "Artery...Tibial,Bladder","Brain...Amygdala",
                            "Brain...Anterior.cingulate.cortex..BA24.",
                            "Brain...Caudate..basal.ganglia.","Brain...Cerebellar.Hemisphere",
                            "Brain...Cerebellum","Brain...Cortex",
                            "Brain...Frontal.Cortex..BA9.","Brain...Hippocampus",
                            "Brain...Hypothalamus","Brain...Nucleus.accumbens..basal.ganglia.",
                            "Brain...Putamen..basal.ganglia.",
                            "Brain...Spinal.cord..cervical.c.1.",
                            "Brain...Substantia.nigra","Breast...Mammary.Tissue",
                            "Cells...Cultured.fibroblasts",
                            "Cells...EBV.transformed.lymphocytes","Cervix...Ectocervix",
                            "Cervix...Endocervix","Colon...Sigmoid","Colon...Transverse",
                            "Esophagus...Gastroesophageal.Junction","Esophagus...Mucosa",
                            "Esophagus...Muscularis","Fallopian.Tube",
                            "Heart...Atrial.Appendage","Heart...Left.Ventricle",
                            "Kidney...Cortex","Kidney...Medulla","Liver","Lung",
                            "Minor.Salivary.Gland","Muscle...Skeletal","Nerve...Tibial",
                            "Ovary","Pancreas","Pituitary","Prostate",
                            "Skin...Not.Sun.Exposed..Suprapubic.",
                            "Skin...Sun.Exposed..Lower.leg.","Small.Intestine...Terminal.Ileum",
                            "Spleen","Stomach","Testis","Thyroid","Uterus","Vagina",
                            "Whole.Blood")
)


for (file in my.files){
  fgsea.res <- read.csv(file = paste(dir_with_fgseaRes, file, sep = ""), header = TRUE, sep = ";")
  fgsea.res$pathway <- as.character(fgsea.res$pathway)
  # fgsea.res <- arrange(fgsea.res, as.character(fgsea.res$pathway))
  for (tiss in fgsea.res$pathway){
    df[[tiss]][df$phen == file] <- -log10(fgsea.res$padj[fgsea.res$pathway == tiss])
  }
}

# df <- df[rowSums(is.na(df)) != ncol(df), ]
df[is.na(df)] <- 0
df[,1] <- gsub(".fgseaRes.csv", "", df[,1])


write.table(df, file = "phens_by_tissues_padj_matr.tsv" ,row.names = FALSE, dec = ".", sep = "\t", quote = FALSE)
