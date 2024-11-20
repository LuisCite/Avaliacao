# Pasta e ordenação de tamanho

read -p "Digite a pasta destino: " dir

if [ -d "$dir" ]; then
    echo "A pasta existe"
    cd "$dir" || exit 1
fi


echo "Ordenação por numero de palavras:"
ls -1 | xargs wc -w | sort

# Backup dir especificos

backup_dir="backup_$(date +%Y-%m-%d)"
mkdir -p "$backup_dir"

mkdir -p "$backup_dir/pequeno"
mkdir -p "$backup_dir/medio"
mkdir -p "$backup_dir/grande"

cp pequeno.txt "$backup_dir/pequeno/"
cp medio.txt "$backup_dir/medio/"
cp grande.txt "$backup_dir/grande/"

echo "Ficheiros copiados para as respetivas pastas de backup"

# relatórios

read -p "Digite o nome ficheiro: " file

if [ ! -f "$file" ]; then
  echo "Erro: ficheiro não encontrado."
  exit 1
fi

num_file=0
tamanho_total=0

for fich in "$dir"/*; do
     if [ -f "$file" ]; then
        NoPalavras=$(wc -w < "$file")
        NoLinhas=$(wc -l < "$file")
        tamanho_file=$(stat --printf="%s" "$file")
        tamanho_total=$((tamanho_total + tamanho_file))
        num_file=$((num_file + 1))
    fi
done

tempo=$(curl -s "https://wttr.in/?format=3")

relatorio="$backup_dir/relatorio_$(date +"%Y-%m-%d").txt"
{
    echo "Informações sobre o ficheiro:"
    echo "------------------------"
    echo "Nome do ficheiro selecionado: $file"
    echo "Tamanho do ficheiro: $tamanho_file bytes"
    echo "Número de Linhas: $NoLinhas"
    echo "Número de Palavras: $NoPalavras"
    echo "Previsão do tempo: $tempo"
    echo
} > "$relatorio"

# Exibe relatório e mostra ao utilizador onde foi guardado
cat "$relatorio"
echo "Relatório salvo em: $relatorio"