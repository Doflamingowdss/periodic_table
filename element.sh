#!/bin/bash

# Exit early if no argument is passed
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Set up PostgreSQL command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Try to find the element by atomic_number, symbol, or name
if [[ $1 =~ ^[0-9]+$ ]]; then
  CONDITION="atomic_number = $1"
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
  CONDITION="symbol = '$1'"
else
  CONDITION="name = '$1'"
fi

# Query to get element data
ELEMENT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE $CONDITION;")

# If not found
if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Parse the result
IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELT BOIL <<< "$ELEMENT"

# Print the formatted result
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
