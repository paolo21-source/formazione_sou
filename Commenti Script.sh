#(COMMENTO 1)
# Cleanup
# Run as root, of course.

cd /var/log #Accede alla directory dove si trovano la maggior parte dei file di log nel sistema.

cat /dev/null > messages #Svuota il contenuto del file `messages`, che contiene i log del syslog daemon (`rsyslogd`, `syslogd`).  Il comando `cat /dev/null > file` è un modo per svuotare un file.

cat /dev/null > wtmp #Anche `wtmp` viene svuotato. Questo file tiene traccia degli accessi e disconnessioni degli utenti (`who`, `last`, `w` lo usano). Svuotarlo rimuove la cronologia delle sessioni utente.

echo "Log files cleaned up." #Messaggio finale di conferma per l’utente.

#----------------
#----------------


#(COMMENTO 2)
#!/bin/bash Script deve essere eseguito con bash
# am-i-root.sh:   Am I root or not?
 
ROOT_UID=0   # Root has $UID 0. #UID (User IDentifier) 0 è riservato all'utente root.

if [ "$UID" -eq "$ROOT_UID" ]  # Will the real "root" please stand up? -- Verifica se l'utente corrente ha UID 0, ovvero se è root.
then
  echo "You are root." # Se è 0 stampa "tu sei root"
else
  echo "You are just an ordinary user (but mom loves you just the same)." #Altrimenti stampa "sei un utente normale"
fi 
 
exit 0 #Termina lo script con codice di uscita `0` (che significa "nessun errore").  Tutto ciò che segue non viene eseguito.
 
# ============================================================= #
# Code below will not execute, because the script already exited.
 
# An alternate method of getting to the root of matters:
 
ROOTUSER_NAME=root #Definisce il nome di root
 
username=`id -nu`              # Or...   username=`whoami`. Ottiene il nome dell'utente corrente 
if [ "$username" = "$ROOTUSER_NAME" ] #Confronta il nome utente corrente con la variabile root, per decidere se è root oppure no.
then
  echo "Rooty, toot, toot. You are root."
else
  echo "You are just a regular fella."
fi
#Se nome utente corrente e nome rootusername coincidono restituisce rooty rooty ecc.. Altrimenti restituisce "sei un normale utente".

#---------------
#---------------

#(COMMENTO 3)
#!/bin/bash Script deve essere eseguito con bash
 
# Call this script with at least 10 parameters, for example
# ./scriptname 1 2 3 4 5 6 7 8 9 10

MINPARAMS=10 #Variabile che definisce il numero minimo di parametri richiesti

echo
 
echo "The name of this script is \"$0\"." # Estrae il percorso con cui è stato eseguito lo script 
# Adds ./ for current directory
echo "The name of this script is \"`basename $0`\"." #Estrae solo il nome del file rimuovendo il percorso  
# Strips out path name info (see 'basename')
 
echo
  
if [ -n "$1" ]              # Tested variable is quoted. Controlla se il parametro 1 è "non vuoto" (-n) se è presente lo stampa.
then
 echo "Parameter #1 is $1"  # Need quotes to escape #
fi
 
if [ -n "$2" ] #Controlla se il parametro 2 è "non vuoto" (-n) se è presente lo stampa.
then
 echo "Parameter #2 is $2"
fi

if [ -n "$3" ] #Controlla se il parametro 3 è "non vuoto" (-n) se è presente lo stampa.
then
 echo "Parameter #3 is $3"
fi

# ...
 

if [ -n "${10}" ]  # Parameters > $9 must be enclosed in {brackets}.  Controlla se il parametro 10 è "non vuoto" (-n) se è presente lo stampa.
then
 echo "Parameter #10 is ${10}"
fi

echo "-----------------------------------"
echo "All the command-line parameters are: "$*"" #Passa tutti i parametri stampati come una sola stringa 
 
if [ $# -lt "$MINPARAMS" ] 
then
  echo
  echo "This script needs at least $MINPARAMS command-line arguments!" #Restituisce il numero di parametri passati allo script, se sono meno di 10 manda un messaggio di avviso 
fi 
 
echo
 
exit 0 #termina lo script con codice di uscita 0 (nessun errore)

#--------------------
#--------------------

#(COMMENTO 4)
#!/bin/bash Script deve essere eseguito con bash
# Naked variables
 
echo
 
# When is a variable "naked", i.e., lacking the '$' in front? (Variabile naked = Variabile senza $ davanti, usata solo quando viene assegnata. Se viene letta o usata si usa $)
# When it is being assigned, rather than referenced.
 
# Assignment
a=879 #Assegnamo ad a il valore 879 quindi senza spazi o $
echo "The value of \"a\" is $a." #Viene letta quindi si usa $
 
# Assignment using 'let'
let a=16+5 # let è un comando per eseguire espressioni aritmetiche quindi assegna 21 alla variabile a (16+5)
echo "The value of \"a\" is now $a." 
 
echo
 
# In a 'for' loop (really, a type of disguised assignment):
echo -n "Values of \"a\" in the loop are: " #Viene chiamata assegnazione iterativa dove a prende i valori 7 8 9 11 
for a in 7 8 9 11
do
  echo -n "$a "  #serve per stampare il valore corrente e -n per evitare il ritorno a capo

 
echo
echo
 
# In a 'read' statement (also a type of assignment):
echo -n "Enter \"a\" " 
read a  #Read legge un valore da tastiera e lo assegna alla variabile a 
echo "The value of \"a\" is now $a."
 
echo
 
exit 0


#-----------
#-----------

#COMMENTO (5)

#!/bin/bash Script deve essere eseguito con bash
 
echo hello #stampa hello 
echo $?    # Exit status 0 returned because command executed successfully. Restituisce il comando: stampa hello 
 
lskdf      # Unrecognized command. #Sta chiamando un comando in esistente che genererà errore 
echo $?    # Non-zero exit status returned -- command failed to execute. Restituisce l'ultimo comando eseguito, quindi darà errore, il codice di uscita sarà quindi diverso da 0 
 
echo
 
exit 113   # Will return 113 to shell.
           # To verify this, type "echo $?" after script terminates. Il codice termina con 113 che è possibile verificarlo con:
echo $? #Che restituità 113 
 
#  By convention, an 'exit 0' indicates success,
#+ while a non-zero exit value means an error or anomalous condition.
#  See the "Exit Codes With Special Meanings" appendix.

#----------------
#----------------


#COMMENTO (6) Come utilizzare array associativi in Bash per memorizzare e accedere a dati strutturati 

#!/bin/bash4 Script deve essere eseguito con bash 4 
# fetch_address.sh
 
declare -A address #Indica che -A è un array associativo 
#       -A option declares associative array.
 
address[Charles]="414 W. 10th Ave., Baltimore, MD 21236"  #Ogni chiave è associata a una stringa contenente l'indirizzo 
address[John]="202 E. 3rd St., New York, NY 10009"
address[Wilma]="1854 Vermont Ave, Los Angeles, CA 90023"
 
 
echo "Charles's address is ${address[Charles]}."  #Legge e stampa il valore associato a Charles 
# Charles's address is 414 W. 10th Ave., Baltimore, MD 21236.
echo "Wilma's address is ${address[Wilma]}."
# Wilma's address is 1854 Vermont Ave, Los Angeles, CA 90023.
echo "John's address is ${address[John]}."
# John's address is 202 E. 3rd St., New York, NY 10009.
 
echo
 
echo "${!address[*]}"   # The array indices ... #Restituisce tutte le chiavi dell'array 
# Charles John Wilma


#----------------
#----------------

#COMMENTO (7)

#! /bin/bash Script deve essere eseguito con bash
# progress-bar2.sh 
# Author: Graham Ewart (with reformatting by ABS Guide author).
# Used in ABS Guide with permission (thanks!).
 
# Invoke this script with bash. It doesn't work with sh.
 #è un esempio di come creare una barra di avanzamento testuale (a puntini) in background, utile per accompagnare processi lunghi
interval=1 #intervallo tra i puntini della barra (1 secondo)
long_interval=10 #durata del processo lungo simulato (10 secondi)
 
 #Barra di avanzamento in background {...}
{
     trap "exit" SIGUSR1 #se il processo riceve il segnale SIGUSR1 termina il ciclo while 
     sleep $interval; sleep $interval #2 secondi di ritardo iniziale prima di stampare i puntini 
     while true #ciclo infinito che stampa . ogni secondo 
     do
       echo -n '.'     # Use dots.
       sleep $interval
     done; } &         # Start a progress bar as a background process.
 
pid=$! #contiene il process id dell'ultimo comando avviato in background. 
trap "echo !; kill -USR1 $pid; wait $pid"  EXIT        # To handle ^C. -- Quando lo script termina in qualunque modo,si attiva il trap su EXIT. Ci assicuriamo che la barra venga terminata quando lo script finisce 
 # stampa !.   Manda il segnale SIGUSR1 al processo della barra che lo termina. Usa wait per attendere che il processo in background finisca prima di proseguire 

echo -n 'Long-running process ' #Stampa il messaggio iniziale 
sleep $long_interval #Simula un processo lungo 10 secondi 
echo ' Finished!' #Stampa il messaggio Finished 
 
kill -USR1 $pid # Manda manualmente SIGUSR1 alla progress bar per fermarla. 
wait $pid              # Stop the progress bar. si assicura che il processo background termini prima di andare avanti.
trap EXIT #Resetta il trap 
 
exit $? #Esce dallo script restituendo l'exit code dell'ultimo comando. 