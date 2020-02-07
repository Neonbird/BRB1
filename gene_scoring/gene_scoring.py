import gzip
from sys import argv
from math import log10, sqrt

with open("snp_genes.tsv", "r") as annotation:
    snp_genes = {}
    gene_scores = {}
    for line in annotation:
        cols = line.strip().split()
        snp_genes[cols[0]] = [cols[4], int(cols[5])]  # create dict with format {variant:[gene, distance, chr, gene start]}
        if cols[4] not in gene_scores:
            gene_scores[cols[4]] = [0, 0, cols[1], cols[6]]
with gzip.open(argv[1], "rt") as summary:
    check_cols = summary.readline().rstrip().split()  # Read header

    for col_index in range(len(check_cols)):
        if check_cols[col_index] == "low_confidence_variant":
            lc_i = col_index
        elif check_cols[col_index] == "beta":
            b_i = col_index
        elif check_cols[col_index] == "pval":
            pval_i = col_index

    for line in summary:
        cols = line.strip().split("\t")
        if cols[lc_i] == "true":  # or sqrt(abs(snp_genes[cols[0]][1]) > int(argv[1])):
            continue
        cur_gene = snp_genes[cols[0]][0]
        gene_scores[cur_gene][0] += float(cols[b_i]) * -log10(float(cols[pval_i]))
        gene_scores[cur_gene][1] += 1

print("{}\t{}\t{}\t{}\t{}".format("Chromosome", "Gene", "Score", "Gene_start", "Number_of_SNP"))
for gene, score in gene_scores.items():
    if score[1] == 0:
        continue
    print("{}\t{}\t{}\t{}\t{}".format(score[2], gene, score[0] / score[1], score[3], score[1]))
