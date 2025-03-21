#!/bin/bash

# Placeholder script


if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

element=$1
# Logic for element lookup will go here
