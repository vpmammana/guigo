cat CNAE_DASH_220521.csv | sed 's/"//g' | awk 'BEGIN{for(q=1; q<=NF+2; q++){classe[q]="";} FS="#"}{  classe[1]="CNAE"; for (i=1; i<NF; i++){ if ($i!=""){ transicao=i+1; classe[i+1] = $i;}} for (m=transicao+1; m<=NF; m++){classe[m]="";} for (k=1;k<=NF+1;k++){ if (classe[k] == ""){ultimo = k; break;}} print "call insere_a_direita_dos_filhos(\""classe[ultimo-2]"\",\""classe[ultimo-1]"\",\""$NF"\");"; }'


