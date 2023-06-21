#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
    # if input is atomic num
    ATOMIC_NUM=$1
    ATOMIC_NUM_ELEMENT=$($PSQL "SELECT symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements RIGHT JOIN properties ON elements.atomic_number=properties.atomic_number RIGHT JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number='$ATOMIC_NUM'")
    if [[ -z $ATOMIC_NUM_ELEMENT ]]
    then
        # if input is symbol
        SYMBOL=$1
        SYMBOL_ELEMENT=$($PSQL "SELECT elements.atomic_number, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements RIGHT JOIN properties ON elements.atomic_number=properties.atomic_number RIGHT JOIN types ON properties.type_id=types.type_id WHERE symbol='$SYMBOL'")
        if [[ -z $SYMBOL_ELEMENT ]]
        then
            # if input is name
            NAME=$1
            NAME_ELEMENT=$($PSQL "SELECT elements.atomic_number, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements RIGHT JOIN properties ON elements.atomic_number=properties.atomic_number RIGHT JOIN types ON properties.type_id=types.type_id WHERE name='$NAME'")
            if [[ -z $NAME_ELEMENT ]]
            then
                echo 'I could not find that element in the database.'
            else    
                echo $NAME_ELEMENT | while read ATOMIC_NUM BAR SYMBOL BAR MASS BAR MELT BAR BOIL BAR TYPE
                do
                    echo -e "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
                done
        fi
        else    
            echo $SYMBOL_ELEMENT | while read ATOMIC_NUM BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
            do
                echo -e "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
            done
        fi
    else
        echo $ATOMIC_NUM_ELEMENT | while read SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
        do
            echo -e "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
        done
    fi
else
    echo 'Please provide an element as an argument.'
fi
    
