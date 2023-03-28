#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
"$($PSQL "TRUNCATE games, teams;")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPP WINNER_GOALS OPP_GOALS 
do
  if [[ $YEAR != "year" ]]
  then 
    # insert teams
    INSERT_WINNER_RESULT="$($PSQL "INSERT INTO teams(name) SELECT '$WINNER' WHERE NOT EXISTS (SELECT team_id FROM teams WHERE name='$WINNER');")"
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    then 
      echo Inserted into teams, $WINNER
    fi
    INSERT_OPP_RESULT="$($PSQL "INSERT INTO teams(name) SELECT '$OPP' WHERE NOT EXISTS (SELECT team_id FROM teams WHERE name='$OPP');")"
    if [[ $INSERT_OPP_RESULT == "INSERT 0 1" ]]
    then 
      echo Inserted into teams, $OPP
    fi
    # get winner and opp id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
    OPP_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPP';")"

    #insert games
    INSERT_GAME_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) SELECT $YEAR, '$ROUND', $WINNER_ID, $OPP_ID, $WINNER_GOALS, $OPP_GOALS WHERE NOT EXISTS (SELECT game_id FROM games WHERE winner_id=$WINNER_ID AND opponent_id=$OPP_ID);")"
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then 
      echo Inserted into games, $YEAR $ROUND
    fi
  fi
done
