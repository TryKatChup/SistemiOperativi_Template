#!/bin/bash

##Controllo argomenti
if [[ $# -ne 3 ]]; then
    #1>&2 redirige stdout in stderr
    echo "Errore: numero di argomenti non corretto" 1>&2
    #uso -e per interpretare i caratteri speciali (\n,\t etc)
    echo -e "Usage:\n\t$0 Stringa M dir1 ... dirN" 1>&2
    exit 1
fi

# Controllo se il carattere è un intero positivo
if [[ $2 = *[!0-9]* ]] ; then
    echo "$2 non è un intero positivo" 1>&2
    exit 1
fi

## Controllo se $1 esiste ed è una directory
## -f regularfile, -e exist
## man test per maggiori informazioni
if ! [[ -d "$1" ]] ; then
    echo -e "Il file $1 non è una directory" 
    exit 1
fi

# Controllo se ho il percorso assoluto della cartella indicata da $1

case $1 in
    /*)
    ;;
    *)
        echo "Errore parametro 1: $1 deve essere un path assoluto"
        exit 2
    ;;
esac

## Esempio di creazione file output 
## (nella cartella dove è stato eseguito il bash)
## scrivo solo due parametri che mi interessano
echo "$1" "$count" >> `pwd`/esito.out
##oppure
outfile="`pwd`/esito.out"
> "$outfile"
# Shift di due parametri a sinistra, così considero i parametri dal 3 in poi (da quelli di partenza)
shift 2

# Creo un figlio per eseguire top:
# Uso & per mettere il processo in background, intanto che 
# Il padre continua ad eseguire il suo codice 
# Mettere in background: fare un figlio

# Il seguente figlio esegue ogni 1.5 secondi top, e poi viene killato
top -b > processi.out &
pidP1=`pidof top`
echo "pidP1 = $pidP1"
kill -9 $pidP1

# Controllo i percorsi, in modo da trovare l'altro script da eseguire 
case "$0" in
    # La directory inizia per / Path assoluto.
    /*) 
    dir_name=`dirname $0`
    recursive_command="$dir_name"/rec_search.sh
    ;;
    */*)
    # La directory non inizia per slash, ma ha uno slash al suo interno.
    # Path relativo.
    dir_name=`dirname $0`
    recursive_command="`pwd`/$dir_name/rec_search.sh"
    ;;
    *)
    # Path né assoluto nP relativo, il comando deve essere nel $PATH
    # Comando nel path
    recursive_command=rec_search.sh
    ;;
esac
$recursive_command $1 $2 $3

#/----------------------------------//
#/          OPERAZIONI BASH         //
#/----------------------------------//

myVal1=`expr 30 / 10`

#/----------------------------------//
#/               TEST               //
#/----------------------------------//
#   Questo comando permette la valutazione di una espressione secondo la sintassi:
#       
#       test [espressione]
#
# La sua chiamata restituisce uno stato positivo (valore = 0) o uno stato negativo (valore != 0) con un comportamento opposto riseptto al C.
test –f <nomefile>  # esistenza di file.
test –d <nomefile>  # esistenza di direttori.
test –r <nomefile>  # diritto di lettura sul file (-w e –x).
test -z <stringa>   # vero se stringa nulla.
test <stringa>      # vero se stringa non nulla.
test <stringa1> = <stringa2>    # uguaglianza stringhe.
test <stringa1> != <stringa2>   # diversità stringhe.
test <val1> -gt <val2> # val1>val2 (numerico).
test <val1> -lt <val2> # val1<val2 (numerico).
test <val1> -ge <val2> # val1>=val2 (numerico).
test <val1> -le <val2> # val1<=val2 (numerico).

-a #operatore che mette in AND equivale a && in C.
-o #operatore che mette in OR equivale a || in C.

#/----------------------------------//
#/               FOR                //
#/----------------------------------//
for <var> in <list> # list=lista di stringhe
do
    <comandi>
done
# Il costrutto scansiona la lista <list> e ripete il corpo del ciclo per ogni stringa presente nella lista.
# Scrivendo solo for i si itera con valori di i in $*, quindi si itera sui parametri in ingresso $1 $2 $3 ...ecc.
for i in 0 1 2 3 4 5 6
do
    echo $i
done
#/----------------------------------//
#/  MANIPOLAZIONE DEGLI ARGOMENTI   //
#/----------------------------------// 
$0          # nome dell'comando bash in esecuzione.
$1,$2,...   # parametri del comando bash in esecuzione.
$*          # insieme di tutte le variabili posizionali, che corrispondono ad argomenti del comando: $1, $2, ecc.
$#          # numero di argomenti passati ($0 escluso).
$?          # valore (int) restituito dall'ultimo comando eseguito. ---> zero: OK, valore positivo: errore
$$          # id numerico del processo in esecuzione (pid).

shift       # permettere di scorrere gli argomenti del comando bash (non altera $0).
set         # permette di risettare gli argomenti del comando bash (non altera $0).



# Count ALL files in a directory AND SUBDIRECTORIES

conta_files=$(find $1 -type f 2> /dev/null | wc -l)

# Count ALL files in a directory NO SUBDIRECTORIES

conta_files=$(find $1 -maxdepth 1 -type f 2> /dev/null | wc -l)


#Check if directory exists, if it does delete all the files inside else creates it

if ! [[ -d "$3" ]] ; then
    mkdir "$3"
else
  rm -rf "$3"/*
fi

# Get first n elements from folder sorted by alphabetical order INCLUDES FOLDERS!!
ls "$dir" | sort | head -n "$2"

# Get first n ONLY FILES from folder sorted by alphabetical order
find "$dir" -maxdepth 1 -type f -printf "%f\n" | sort | head -n "$2"