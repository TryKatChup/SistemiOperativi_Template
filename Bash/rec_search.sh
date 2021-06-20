#!/bin/bash
for file in $1/*; do
  if [[ -f "$file" ]]; then
    # Faccio cose
  elif [[ -d "$file" ]]; then
    echo "Ricorsione nella directories $file"
    # Chiamata ricorsiva
    "$0" "$file" "$2" "$3"
  fi
done
##############################################
#############      NOTA BENE     #############
##############################################

#SE NON FACCIO CD $1 I FILE CHE ANALIZZO UNO PER UNO NON AVRANNO IL PERCORSO ASSOLUTO, BENSI
#SOLO IL NOME DEL FILE, PERTANTO OCCHIO CON PWD.
#USARE PWD SOLO SE RICHIESTO, OPPURE SE SI SCRIVE CD $1 PER RIFERIRSI ALLA CARTELLA ATTUALE

## Controllare che un file (senza percorso assoluto, solo nome del file) inizi per una determinata stringa
if [[ $(basename $file) == "$2"* ]]; then
  # Inserire codice qui
fi

# Iterate over all subdirectories
directories=()
while IFS= read -r -d $'\0'; do
  directories+=("$REPLY")
done < <(find "$1" -type d -print0)
for dir in "${directories[@]}"; do
  echo "$dir"
done

# Iterate over all files in a directory BUT ONLY THE CURRENT ONE
files=()
while IFS= read -r -d $'\0'; do
  files+=("$REPLY")
done < <(find "$1" -maxdepth 1 -type f -print0)
for file in "${files[@]}"; do
  echo "$file"
done

# Iterate over all files in a directory AND SUBDIRECTORIES
files=()
while IFS= read -r -d $'\0'; do
  files+=("$REPLY")
done < <(find "$1" -type f -print0)
for file in "${files[@]}"; do
  echo "$file"
done

#Iterate over all subdirectories and ALL THE FILES in those subdirectoies

directories=()
while IFS= read -r -d $'\0'; do
  directories+=("$REPLY")
done < <(find "$1" -type d -print0)
for dir in "${directories[@]}"; do
  files=()
  while IFS= read -r -d $'\0'; do
    files+=("$REPLY")
  done < <(find "$dir" -type f -print0)
  for file in "${files[@]}"; do
    echo "$file"
  done
done


#Operate on all subdirectories and "save" them based on condition (variation of line #25 with code inside)
directories=()
while IFS= read -r -d $'\0'; do
  directories+=("$REPLY")
done < <(find "$1" -type d -print0)
for dir in "${directories[@]}"; do
  conta_files=$(find "$dir" -maxdepth 1 -type f -name "$2*" 2>/dev/null | wc -l)
  if [ "$conta_files" -gt "$3" ]; then
    echo "$dir" "$conta_files" >>"$PWD"/esito.out
  fi
done