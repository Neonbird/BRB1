import gffutils
import pandas
#подгружаем аннотацию один!! раз, она одна для всех
# #anot_db = gffutils.create_db("/home/neobird/BI/BRB1/gencode.v19.annotation.gtf_withproteinids",
#                            dbfn='anot.db', force=True, keep_order=True,
#                           disable_infer_genes=True, disable_infer_transcripts=True)

anot_db = gffutils.FeatureDB('anot.db', keep_order=True)

genes = {'name':[], 'chr':[], 'start':[], 'end':[]}
for gene in anot_db.features_of_type('gene'):
    if gene.attributes.items()[2][1] == ['protein_coding']:
        genes['name'].append(gene.attributes.items()[4][1][0])
        genes['chr'].append(gene.chrom.replace('chr',''))
        genes['start'].append(gene.start)
        genes['end'].append(gene.end)
df_genes = pandas.DataFrame.from_dict(genes)

#считывание суммарных статитсик гвас, грубо говоря snp для определённого фенотипа в датафрейм
df_snp = pandas.read_csv("/home/neobird/BI/BRB1/100001_irnt.gwas.imputed_v3.both_sexes.tsv",  sep='	',
                         usecols=['variant', 'pval'], nrows = 1000)
#разбить колонку variant на две
df_snp[['chr','position_with_trash']] = df_snp['variant'].str.split(':', n = 1, expand =True)
#создать колоку с позицией снипа на основе др колонки
df_snp['position'] = [i[0] for i in df_snp.position_with_trash.str.split(':')]
#удалить лишние колонки
del df_snp['variant']
del df_snp['position_with_trash']
#поменять порядок колонок
df_snp = df_snp[['chr','pval', 'position']]
#print(df_snp)
#print(df_genes)

dict_genes_snp = {}
for chr_type in ('1','2', '3', '4', '5', '6', '7', '8', '9', '10',
                 '11', '12', '13', '14', '15', '16', '17', '18',
                 '19', '20', '21', '22', 'M', 'X', 'Y'):
    # создаём датафреймы по генам и снипам только для одного типа хромосом
    df_snp_chr = df_snp.loc[df_snp.chr == chr_type]
    df_genes_chr = df_genes.loc[df_genes.chr == chr_type]
    #идём для каждого гена по строкам снипов с той же хромосомы, смотрим, входит ли снип в него
    for gene_row in df_genes_chr.itertuples(index=False):
        name_of_gene = gene_row[0]
        start_of_gene = int(gene_row[2])
        end_of_gene = int(gene_row[3])
        for snp_row in df_snp_chr.itertuples(index = False):
            pval_of_snp = snp_row[1]
            # проверка, не является ли пвал NaN
            if pval_of_snp == 'NaN':
                break
            #     если явялется, берём сразу следующий снип
            else:
                pval_of_snp = float(pval_of_snp)
            position_of_snp = int(snp_row[2])
            # проверяем, входит ли снип в этот ген
            if position_of_snp >= start_of_gene and position_of_snp <= end_of_gene:
                # если ген ещё не в словаре то, присваимаем ему этот пвал
                # если ген в словаре, если данный пвал меньше чем тот, что записан в словаре,
                # меняем его на этот меньший пвал
                if name_of_gene not in dict_genes_snp or pval_of_snp < dict_genes_snp[name_of_gene]:
                        dict_genes_snp[name_of_gene] = pval_of_snp
#print(dict_genes_snp)

import csv
with open('gene_pval_100001_irnt.gwas.imputed_v3.both_sexes.csv', 'w') as csv_file:
    writer = csv.writer(csv_file)
    for key, value in dict_genes_snp.items():
       writer.writerow([key, value])
