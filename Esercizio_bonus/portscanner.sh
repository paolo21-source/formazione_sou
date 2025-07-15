#!/bin/bash

usage() {
  echo "Usage: $0 <host> <start_port> <end_port>"
  exit 1
}


if [ "$#" -ne 3 ]; then
  usage
fi

HOST="$1"
START_PORT="$2"
END_PORT="$3"




if [[ -z "$HOST" ]]; then
  echo "Errore: host non valido"
  exit 1
fi


if ! [[ "$START_PORT" =~ ^[0-9]+$ ]] || ! [[ "$END_PORT" =~ ^[0-9]+$ ]]; then
  echo "Errore: le porte devono essere numeri interi"
  exit 1
fi

if (( START_PORT < 1 || START_PORT > 65535 )); then
  echo "Errore: porta iniziale fuori range"
  exit 1
fi

if (( END_PORT < 1 || END_PORT > 65535 )); then
  echo "Errore: porta finale fuori range"
  exit 1
fi

if (( END_PORT < START_PORT )); then
  echo "Errore: porta finale deve essere >= porta iniziale"
  exit 1
fi


for ((port=START_PORT; port<=END_PORT; port++)); do
  
  nc -w 1 "$HOST" "$port" < /dev/null >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Porta $port: APERTA"
  fi
done


