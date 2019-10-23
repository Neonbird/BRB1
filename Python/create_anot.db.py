import gffutils
import sys

#создаем аннотацию один!! раз, она одна для всех фенотипов
anot_db = gffutils.create_db(sys.argv[1],
                           dbfn='anot.db', force=True, keep_order=True,
                          disable_infer_genes=True, disable_infer_transcripts=True)
