cat teste.csv | sed 's/"//g' | awk 'BEGIN{pai="CNAE"; profundidade_velho=0;  FS="#"}{ for (i=1; i<NF; i++){printf "%s",$i;} print ""; }'
