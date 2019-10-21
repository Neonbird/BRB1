import gffutils

#создаем аннотацию один!! раз, она одна для всех фенотипов
anot_db = gffutils.create_db("/home/neobird/BI/BRB1/gencode.v19.annotation.gtf_withproteinids",
                           dbfn='anot.db', force=True, keep_order=True,
                          disable_infer_genes=True, disable_infer_transcripts=True)