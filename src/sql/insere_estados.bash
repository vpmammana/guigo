cat estados_brasileiros.txt | awk 'BEGIN {FS=",";}{print "INSERT INTO estados (nome_estado, id_pais, sigla_estado, usuario) VALUES (\""$1"\",(SELECT id_chave_pais from paises WHERE nome_pais like \"Brasil\") ,\""$2"\", \"victor\");"}'
