# Project goal:
Сетевой анализ генетических взаимодействий и поиск взаимосвязей между признаками и тканями/клеточными типами с использованием GWAS-данных.

# Tasks:
1. Поиск оптимального подхода для расчета gene score - меры значимости связи гена и признака по summary statistics из GWAS. 
2. Сетевой анализ генетических взаимосвязей
3. Анализ взаимосвязей признаков и тканей/клеточных типов
4. Веб-интерфейс для функциональной аннотации GWAS-данных с использованием других GWAS-данных.


# Поиск оптимального подхода для расчета gene score - меры значимости связи гена и признака по summary statistics из GWAS. 
## a brief description of the methods used;
В папке Python находятся скрипты для работы с данными Миша делай  с ними что хочешь мб нафег удолить
Чтобы работать со скриптами, надо на основе аннотации генома человека создать database с помощью create_anot.db.py

## system requirements for the developed software (memory / CPU requirements, required version of the operating system, interpreter, libraries, etc.);
## instructions for launching the developed software (for a console application - description of startup keys, examples of commands with selected keys);
## examples of results obtained using software (text, graphs, tables, etc.);

# Network analysis
### a brief description of the methods used:
Hierarchical clustering, GSEA, SAFE-graphs visualisation
### system requirements for the developed software: 
python 3.6, 16Gb RAM
### instructions for launching the developed software:
```
pip install matplotlib sklearn numpy pandas scipy networkx tqdm jupyter
jupyter notebook network_analysis/Network_analysis.ipynb
```
### examples of results obtained using software 
you can see in network_analysis/Network_analysis.ipynb


# Analysis of the relationship of signs and tissues / cell types
## a brief description of the methods used
A script `tiss_diff_exp.R` was written to determine tissue-specific differential expression of genes important for the development of a phenotype of interest. It takes an input file from the median gene-level TPM by tissue and a folder containing files with genescores, and on the basis of r-package fgsea that implements an algorithm for fast gene set enrichment analysis, calculates statistics for this phenotype and all used tissues. 
To evaluate the precence of association of the phenotype with tissue based on this statistics and create a matrix, thanks to which it is possible to compare the associations of tissues with several phenotypes, a script `phen_tissues.R` was written. It takes a directory with stastics files as an input and output is a matrix in which each pair of tissue-phenotype corresponds to either 1 (there is a significant relationship between gene expression in a given tissue and phenotype) or 0 (there is no significant relationship). The resulting matrix was used for further visualization and hierarchical clustering using Phantasus v1.5.1
There some additional scripts that were used:
+ `del_rowscols_withonly_0.R` that deletes all rows and columns consisting of only 0
+ `phen_tissues_padj_matr.R` like the tiss_diff_exp.R, it creates a matrix, but for each pair tissue-phenotype does not match 0 or 1, but the p-value adjasted from the results of the fgsea analysis
+ `rename_ph_num_to_descr.R` renames the names of phenotypes in the matrix from code to semantic

## system requirements for the  all developed software 
+ required version of the operating system: Linux 18.04
+ interpreter: R version 3.6.2
+ libraries: data.table v1.12.8, dplyr v0.8.3, ggplot2 v3.2.1, tidyr v1.0.0, BiocManager 1.30.1, fgsea 1.12.0

## `tiss_diff_exp.R`
### instructions for launching
args[\*] arguments:
args[1] - unziped file.gct with TPM by tissue
args[2] - directory that contain summary genescore files (phen_number.sum.genescores.txt) 
          for phenotypes of interest (outputs of Pascal)

Output is a directory named 'fgseaRes' that contains files with names 
<phen_number>.fgseaRes.csv that contains fgsea statistics

Example:
```
$ ls sum_genescores/
> n_1.sum.genescores.txt n_2.sum.genescores.txt n_3.sum.genescores.txt

$ R tiss_diff_exp.R TPM_by_tissue.gct sum_genescores/
> fgseaRes/

$ ls fgseaRes/
> n_1.fgseaRes.csv n_2.fgseaRes.csv n_3.fgseaRes.csv
```
## `phen_tissues.R`
### instructions for launching
args[\*] arguments:
args[1] - name of directory that contains files with names <phen_number>.fgseaRes.csv that contains fgsea statistics

Example:
```
$ ls fgseaRes/
n_1.fgseaRes.csv n_2.fgseaRes.csv n_3.fgseaRes.csv
$ phen_tissues.R fgseaRes/
```

### examples of results
The script produces a table in `.csv` format, in which tissue is used as columns and phenotypes as rows, and cells are filled with either 0 or 1. Output is a matrix in which each pair of tissue-phenotype corresponds to either 1 (there is a significant relationship between gene expression in a given tissue and phenotype) or 0 (there is no significant relationship).

## `del_rowscols_withonly_0.R`
this script is run through the R development environment (for example, RStudio), and the name of the file with the matrix is manually entered into its code, from which it is necessary to remove zero columns and rows. Output - a matrix in which there are no zero rows and columns.

## `phen_tissues_padj_matr.R`
This script works exactly the same as the phen_tissues.R, but instead of 0 and 1, the matrix is filled with p-values adjasted from the statistics of fgsea analises.

## `rename_ph_num_to_descr.R`
For further analysis of the matrix in Phantasus, it is necessary to rename the names of phenotypes from code to semantic. This script is launched from the development environment R and the code needs to be edited manually and the file name with the matrix, as well as the name of the file with the decoding of the phenotype names, should be entered there.

# Веб-интерфейс для функциональной аннотации GWAS-данных с использованием других GWAS-данных.
## a brief description of the methods used;
## system requirements for the developed software (memory / CPU requirements, required version of the operating system, interpreter, libraries, etc.);
## instructions for launching the developed software (for a console application - description of startup keys, examples of commands with selected keys);
## examples of results obtained using software (text, graphs, tables, etc.);



# references to the used databases
Data used as median gene-level TPM by tissue data:
https://storage.googleapis.com/gtex_analysis_v8/rna_seq_data/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_median_tpm.gct.gz

Used annotation of human genome:
ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz

Summary statistics for all phenotypes and background information about them here:
https://docs.google.com/spreadsheets/d/1kvPoupSzsSFBNSztMzl04xMoSC3Kcx3CrjVf4yBmESU/edit?ts=5b5f17db#gid=227859291
