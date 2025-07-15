{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 HelveticaNeue;\f1\fnil\fcharset0 HelveticaNeue-Bold;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{circle\}}{\leveltext\leveltemplateid1\'01\uc0\u9702 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid1}
{\list\listtemplateid2\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{circle\}}{\leveltext\leveltemplateid101\'01\uc0\u9702 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid2}
{\list\listtemplateid3\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{circle\}}{\leveltext\leveltemplateid201\'01\uc0\u9702 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid3}
{\list\listtemplateid4\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{circle\}}{\leveltext\leveltemplateid301\'01\uc0\u9702 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid4}
{\list\listtemplateid5\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{circle\}}{\leveltext\leveltemplateid401\'01\uc0\u9702 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid5}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}{\listoverride\listid2\listoverridecount0\ls2}{\listoverride\listid3\listoverridecount0\ls3}{\listoverride\listid4\listoverridecount0\ls4}{\listoverride\listid5\listoverridecount0\ls5}}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab560
\pard\pardeftab560\slleading20\partightenfactor0

\f0\fs26 \cf0 ESERCIZIO BONUS \
\
\pard\pardeftab560\slleading20\pardirnatural\partightenfactor0
\cf0 #!/bin/bash\
\
\pard\pardeftab560\pardirnatural\partightenfactor0
\ls1\ilvl0\cf0 {\listtext	\uc0\u9702 	}CONTROLLA SE IL NUMERO DI ARGOMENTI PASSATI SIA 3 \'97 IN CASO MANDA UN MESSAGGIO EXIT 1 \
\pard\pardeftab560\slleading20\partightenfactor0
\cf0      if [ $# -ne 3 ]; then\
\pard\pardeftab560\slleading20\pardirnatural\partightenfactor0
\cf0       echo "Usage: $0 <host> <start_port> <end_port>"\
      exit 1\
     fi\
\pard\pardeftab560\slleading20\partightenfactor0
\cf0 \
\
\pard\pardeftab560\pardirnatural\partightenfactor0
\ls2\ilvl0\cf0 {\listtext	\uc0\u9702 	}ASSEGNAZIONE DELLE VARIABILI RICHIAMANDO GLI ARGOMENTI\
\pard\pardeftab560\slleading20\pardirnatural\partightenfactor0
\cf0       HOST=$1\
      START=$2\
      END=$3\
\
\
\pard\pardeftab560\pardirnatural\partightenfactor0
\ls3\ilvl0\cf0 {\listtext	\uc0\u9702 	}DEFINISCE UNA STRINGA CHE CONTIENE SOLO CIFRE DA INIZIO ALLA FINE \'97 VERIFICA CHE I NUMERI SIANO POSITIVI \'97 SE UNO DEI DUE NUM NON \'e8 UN NUM STAMPA ERRORE \
\pard\pardeftab560\slleading20\partightenfactor0
\cf0 (^ \'97 indica l\'92inizio della stringa\
	[0-9] \'97 indica qualsiasi cifra da 0 a 9\
	+ \'97 indica 
\f1\b uno o pi\'f9
\f0\b0  caratteri (in questo caso, cifre) consecutivi\
	$ \'97 indica la fine della stringa)\
\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97 \
      re='^[0-9]+$'\
\pard\pardeftab560\slleading20\pardirnatural\partightenfactor0
\cf0       if ! [[ $START =~ $re && $END =~ $re ]]; then\
         echo "Start and end ports must be numbers"\
         exit 1\
     fi\
\
\
\
\pard\pardeftab560\pardirnatural\partightenfactor0
\ls4\ilvl0\cf0 {\listtext	\uc0\u9702 	}port=$START    						(Inializza port con la porta iniziale)  \
\pard\pardeftab560\slleading20\pardirnatural\partightenfactor0
\cf0       while [ $port -le $END ]; do				(Avvia un ciclo while che continua finch\'e9 port \'e8 minore o uguale a END. \'97 Permette di scansione tutte le porte nel Range)\
        nc -w 1 $HOST $port < /dev/null > /dev/null 2>&1.      	  Usa netta \'97 timeout di un secondo \'97 evita che nc aspetti input da testiera \'97 sopprime output o errore \
        if [ $? -eq 0 ]; then. 					$? \'e8 il codice di uscita dell\'92ultimo comando nc \
          echo "Port $port is open"			Se \'e8 0, vuol dire che la connessione \'e8 andata a buon fine \uc0\u8594  la porta \'e8 aperta.\
        fi\
\pard\pardeftab560\slleading20\partightenfactor0
\cf0 \
\
\
\pard\pardeftab560\pardirnatural\partightenfactor0
\ls5\ilvl0\cf0 {\listtext	\uc0\u9702 	}  ((port++))				Incrementa port di 1 (port = port + 1) \'97 Torna all\'92inizio del ciclo per testare la porta successiva finch\'e9 non supera END.\
\pard\pardeftab560\slleading20\pardirnatural\partightenfactor0
\cf0       done\
}