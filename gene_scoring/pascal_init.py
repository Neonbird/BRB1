# -*- coding: utf-8 -*-
# The script processes UK Biobank phenotype summary statistics and runs PASCAL-tool on it.
# Input: path to file with summary statistics.WARNING: not universal way to file (need to be fixed).
# Output: PASCAL standard output (gene scores)

import gzip
import os
import subprocess
from sys import argv

file = argv[1].split("/")[2]
env = {
    **os.environ,
    "_JAVA_OPTIONS": "-Xmx4g"  # Put JVM heap size in environment variable
}

with gzip.open("variants.tsv.bgz", "rt") as variants, gzip.open("resources/project/" + file, "rt") as treat_summary, open(
        file[:-8] + "_temp" + ".tsv", 'a') as data_for_pascal:

    dict_with_rs_ids = {line.split()[0]: line.split()[5] for line in variants}  # create dict with format variant:rs_id

    check_cols = treat_summary.readline().strip().split()  # read header
    for col_index in range(len(check_cols)):
        if check_cols[col_index] == "low_confidence_variant":
            low_conf_i = col_index
        elif check_cols[col_index] == "pval":
            pvalue_i = col_index

    for line in treat_summary:
        prep_line = line.strip().split()
        if prep_line[low_conf_i] == "true":  # exclude low confidence variants
            continue
        # print("{}\t{}".format(dict_with_rs_ids[prep_line[0]], prep_line[pvalue_i]))
        data_for_pascal.write("{}\t{}\n".format(dict_with_rs_ids[prep_line[0]], prep_line[
            pvalue_i]))  # write rs_id and pvalue of relative variant from treat_summary
    subprocess.run("./Pascal --pval={} --maxsnp=-1".format(file[:-8] + "_temp" + ".tsv"), shell=True, env=env)
    os.remove(file[:-8] + "_temp" + ".tsv")


