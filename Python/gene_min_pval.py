#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""Аргументы sys.arg[*]
sys.arg[1] - файл суммарных статистик file.tsvВАЖНО На данном этапе разработки
должен лежать в той же директории, из которой запускается скрипт!!
sys.arg[2] - путь к к файлу аннтотации annotation.db - его можно создать из файла аннотации *.gff с помощью
скрипта create_anot.db.py.
Пример запуска данного скрипта:
$ python gene_min_pval.py summary_statistics.tsv /mydir/annotation.db
"""
import csv
import sys

import gffutils
import pandas

anot_db = gffutils.FeatureDB(sys.argv[2], keep_order=True)

genes = {'name': [], 'chr': [], 'start': [], 'end': []}
for gene in anot_db.features_of_type('gene'):
    if gene.attributes.items()[2][1] == ['protein_coding']:
        genes['name'].append(gene.attributes.items()[4][1][0])
        genes['chr'].append(gene.chrom.replace('chr', ''))
        genes['start'].append(gene.start)
        genes['end'].append(gene.end)
df_genes = pandas.DataFrame.from_dict(genes)
df_genes[['start', 'end']] = df_genes[['start', 'end']].apply(pandas.to_numeric)

# считывание суммарных статитсик гвас, грубо говоря snp для определённого фенотипа в датафрейм
# работает с файлом в пути, указаном в консоли
df_snp = pandas.read_csv(sys.argv[1], sep='\t', usecols=['variant', 'pval'], nrows=1000)
# удалить все строки, которые содержат хоть где-то NaN
df_snp.dropna()
# разбить колонку variant на две
df_snp[['chr', 'position_with_trash']] = df_snp['variant'].str.split(':', n=1, expand=True)
# создать колоку с позицией снипа на основе др колонки
df_snp['position'] = [i[0] for i in df_snp.position_with_trash.str.split(':')]
# удалить лишние колонки
del df_snp['variant']
del df_snp['position_with_trash']
# поменять порядок колонок
df_snp = df_snp[['chr', 'pval', 'position']]
df_snp[['pval', 'position']] = df_snp[['pval', 'position']].apply(pandas.to_numeric)
# print(df_snp)
# print(df_genes)

dict_genes_minpval = {}
for chr_type in ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
                 '11', '12', '13', '14', '15', '16', '17', '18',
                 '19', '20', '21', '22', 'M', 'X', 'Y'):
    # создаём датафреймы по генам и снипам только для одного типа хромосом
    df_snp_chr = df_snp.loc[df_snp.chr == chr_type]
    df_genes_chr = df_genes.loc[df_genes.chr == chr_type]
    for snp_row in df_snp_chr.itertuples(index=False):
        pval_of_snp = snp_row[1]
        position_of_snp = snp_row[2]
        pval_of_gene = 0
        for gene_row in df_genes_chr.itertuples(index=False):
            name_of_gene = gene_row[0]
            start_of_gene = gene_row[2]
            end_of_gene = gene_row[3]
            if start_of_gene <= position_of_snp <= end_of_gene:
                if name_of_gene not in dict_genes_minpval or dict_genes_minpval[name_of_gene] > pval_of_snp:
                    dict_genes_minpval[name_of_gene] = pval_of_snp

with open('gp.'+ sys.argv[1] + '.csv', 'w') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(['gene_name', 'min_pval'])
    for key, value in dict_genes_minpval.items():
        writer.writerow([key, value])

"""Output
На выходе получается gp.имя_файла_исходных_статистик.csv в папке, из которой запускался скрипт
"""
