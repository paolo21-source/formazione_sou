#!/bin/bash

NODE1="node1"
NODE2="node2"
CONTAINER="echo-server"
IMAGE="ealen/echo-server"

function docker_running_on_node() {
  ssh -F ssh_config $1 "docker ps -q -f name=$CONTAINER"
}

function start_container() {
  echo "Avvio container su $1"
  ssh -F ssh_config $1 "docker run -d --rm --name $CONTAINER -p 8080:80 $IMAGE"
}

function stop_container() {
  echo "Stop container su $1"
  ssh -F ssh_config $1 "docker stop $CONTAINER 2>/dev/null || true"
}

while true; do
  echo "=== $(date) ==="
  r1=$(docker_running_on_node $NODE1)
  r2=$(docker_running_on_node $NODE2)

  if [ -n "$r1" ]; then 
    echo "Container attivo su NODE1, migro su NODE2"
    stop_container $NODE1
    start_container $NODE2
  elif [ -n "$r2" ]; then
    echo "Container attivo su NODE2, migro su NODE1"
    stop_container $NODE2
    start_container $NODE1
  else
    echo "Container non trovato, avvio su NODE1"
    start_container $NODE1
  fi

  sleep 60
done