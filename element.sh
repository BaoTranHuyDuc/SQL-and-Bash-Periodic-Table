PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z "$1" ]]
then
  echo Please provide an element as an argument.
else
  ATOMIC_NUMBER_TO_CHECK=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  
  #loop if input is atomic number
  if [[ -n $ATOMIC_NUMBER_TO_CHECK ]]
  then
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER_TO_CHECK")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER_TO_CHECK")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER_TO_CHECK")
    TYPE=$($PSQL "SELECT types.type FROM types RIGHT JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER_TO_CHECK")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER_TO_CHECK")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER_TO_CHECK")
    echo "The element with atomic number $ATOMIC_NUMBER_TO_CHECK is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  
  #loop if input is name
  else
    ELEMENT_NAME_TO_CHECK=$($PSQL "SELECT name FROM elements WHERE name='$1'")
    if [[ -n $ELEMENT_NAME_TO_CHECK ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT_NAME_TO_CHECK'")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$ELEMENT_NAME_TO_CHECK'")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties FULL JOIN elements USING(atomic_number) WHERE name='$ELEMENT_NAME_TO_CHECK'")
      TYPE=$($PSQL "SELECT types.type FROM types RIGHT JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE name='$ELEMENT_NAME_TO_CHECK'")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties FULL JOIN elements USING(atomic_number) WHERE name='$ELEMENT_NAME_TO_CHECK'")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) WHERE name='$ELEMENT_NAME_TO_CHECK'")
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME_TO_CHECK ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME_TO_CHECK has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

    #loop if input is element symbol
    else
      SYMBOL_TO_CHECK=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
      if [[ -n $SYMBOL_TO_CHECK ]]
      then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL_TO_CHECK'")
        ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL_TO_CHECK'")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties FULL JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL_TO_CHECK'")
        TYPE=$($PSQL "SELECT types.type FROM types RIGHT JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL_TO_CHECK'")
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties FULL JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL_TO_CHECK'")
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL_TO_CHECK'")
        echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL_TO_CHECK). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      else
        echo I could not find that element in the database.
      fi
    fi
  fi
fi
