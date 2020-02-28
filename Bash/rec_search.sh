#!/bin/bash
for file in $1/*  ; do 
    if [[ -f "$file" ]] ; then
        # Faccio cose  
    elif [[ -d "$file" ]] ; then
        echo "Ricorsione nella directory $file"
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
if [[ `basename $file` == "$2"* ]] ; then
    # Inserire codice qui
fi
