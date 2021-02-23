#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ -z $1 ]]
then
  echo 'Please provide an element as an argument.'
  exit
fi

if [[ $1 =~ ^[a-zA-Z]+$ ]]
then
  ELEMENT=$($PSQL "SELECT elements.atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties on elements.atomic_number = properties.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE symbol = '$1' OR name = '$1'")
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT elements.atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties on elements.atomic_number = properties.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1")
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo $ELEMENT | while IFS="|" read NUMBER SYMBOL NAME TYPE MASS MELT BOIL
do
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done
