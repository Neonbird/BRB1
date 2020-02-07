# Цель проекта:
Сетевой анализ генетических взаимодействий и поиск взаимосвязей между признаками и тканями/клеточными типами с использованием GWAS-данных.

# Задачи:
1. Поиск оптимального подхода для расчета gene score - меры значимости связи гена и признака по summary statistics из GWAS. 
2. Сетевой анализ генетических взаимосвязей
3. Анализ взаимосвязей признаков и тканей/клеточных типов
4. Веб-интерфейс для функциональной аннотации GWAS-данных с использованием других GWAS-данных.

Methods:
1. Pascal
2. sklearn
3. GSEA
4. safepy

# Поиск оптимального подхода для расчета gene score - меры значимости связи гена и признака по summary statistics из GWAS. 
## a brief description of the methods used;
В папке Python находятся скрипты для работы с данными Миша делай  с ними что хочешь мб нафег удолить
Чтобы работать со скриптами, надо на основе аннотации генома человека создать database с помощью create_anot.db.py

## system requirements for the developed software (memory / CPU requirements, required version of the operating system, interpreter, libraries, etc.);
## instructions for launching the developed software (for a console application - description of startup keys, examples of commands with selected keys);
## examples of results obtained using software (text, graphs, tables, etc.);

# Сетевой анализ генетических взаимосвязей
## a brief description of the methods used;
## system requirements for the developed software (memory / CPU requirements, required version of the operating system, interpreter, libraries, etc.);
## instructions for launching the developed software (for a console application - description of startup keys, examples of commands with selected keys);
## examples of results obtained using software (text, graphs, tables, etc.);
### Минимальные требования:
python 3.6, 16Gb RAM

# Анализ взаимосвязей признаков и тканей/клеточных типов
## a brief description of the methods used;
## system requirements for the developed software (memory / CPU requirements, required version of the operating system, interpreter, libraries, etc.);
## instructions for launching the developed software (for a console application - description of startup keys, examples of commands with selected keys);
## examples of results obtained using software (text, graphs, tables, etc.);

# Веб-интерфейс для функциональной аннотации GWAS-данных с использованием других GWAS-данных.
According to the GWAS data, it’s nice to give out information about (this is what we want):
* what molecular pathways and sets of genes are associated with its trait
* what previously done GWAS experiments are similar to his experiment
* which modules of genetic architecture are involved in its trait.

**Languages** : *Java* (+ *Python* - language of tools)
**Framework**: *Spring* + *Thymeleaf*
Unfortunately, difficulties arose (for example, the need to refine *LSEA*, difficulties in writing), so for now there is only a semi-working version that should soon work.
It is not possible to start a server on a laptop (as well as *LSEA* itself), therefore a server is needed (or maybe 16+ RAM).
*Interface:*
![](img/screen1.png)
Analysis:
![](img/screen2.png)



# References to the used literature, databases, etc.
Данные для работы по проекту BRB1.


Данные для создания database аннотации генома человека:
ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz

Суммарные статистики по всем фенотипам и справочная информация о них лежит тут:
https://docs.google.com/spreadsheets/d/1kvPoupSzsSFBNSztMzl04xMoSC3Kcx3CrjVf4yBmESU/edit?ts=5b5f17db#gid=227859291



