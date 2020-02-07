!/bin/bash
​
#  Scoring genes for each phenotype with Pascal tool
​
DATENOW=$( date )
echo "Started scoring genes at: $DATENOW"
export _JAVA_OPTIONS="-Xmx16g"
​
for phenotype in ../imputed_v3/*.bgz
do
        while [ $( ps -AF | grep '/bin/bash ./Pascal' | wc -l ) -ge 24 ]; do sleep 1 ; done
        python3 pascal_init.py $phenotype &
done
wait
​
DATENOW=$( date )
echo "Finished scroring genes at: $DATENOW"
