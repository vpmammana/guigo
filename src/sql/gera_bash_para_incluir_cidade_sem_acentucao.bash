cat arquivo_cidades.txt  | awk '
BEGIN{FS=","}
{guarda=$1; 
gsub(/á/,"A",$1);
gsub(/Á/,"A",$1);
gsub(/à/,"A",$1);
gsub(/À/,"A",$1);
gsub(/ã/,"A",$1); 
gsub(/Ã/,"A",$1);
gsub(/â/,"A",$1);
gsub(/Â/,"A",$1);
gsub(/é/,"E",$1);
gsub(/É/,"E",$1);
gsub(/ê/,"E",$1);
gsub(/Ê/,"E",$1);
gsub(/í/,"I",$1);
gsub(/Í/,"I",$1);
gsub(/ó/,"O",$1);
gsub(/Ó/,"O",$1);
gsub(/õ/,"O",$1);
gsub(/Õ/,"O",$1);
gsub(/ô/,"O",$1);
gsub(/Ô/,"O",$1);
gsub(/ú/,"U",$1);
gsub(/Ú/,"U",$1);
gsub(/ç/,"C",$1);
gsub(/Ç/,"C",$1);

print "sed -i \"s/'\''"guarda"'\''/'\''"guarda"'\'','\''"toupper($1)"'\''/g\" apenas_insert_into_cidades.sql"}'
