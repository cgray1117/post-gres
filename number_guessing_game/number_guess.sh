#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

N=$(( RANDOM % 1001 ))

echo "Enter your username:"
read USERNAME

# get user is
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ $USER_ID ]]; then

    # get games played
    GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = $USER_ID")
   
    # get best guess
    BEST_GUESS=$($PSQL "SELECT MIN(guess) FROM games WHERE user_id = $USER_ID")

    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GUESS guesses."

    #INSERT_GAME=$($PSQL "INSERT INTO games(username) VALUES('$USERNAME')")
    #CURRENT_GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games")
    #UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$USERNAME';")
else 
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    
    # insert to users table
    INSERTED_TO_USERS=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
    
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
fi

TRIES=0
GUESSED=0

echo -e "\nGuess the secret number between 1 and 1000:"

  while [[ $GUESSED = 0 ]]; do
    read GUESS

    # if not a number
    if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
      echo -e "\nThat is not an integer, guess again:"

    # if correct guess
    elif [[ $N = $GUESS ]]; then
      TRIES=$(($TRIES + 1))
      echo -e "\nYou guessed it in $TRIES tries. The secret number was $N. Nice job!"
      
      # insert into db
      INSERTED_TO_GAMES=$($PSQL "INSERT INTO games(user_id, guess) VALUES($USER_ID, $TRIES)")
      GUESSED=1
    
    # if greater
    elif [[ $N -gt $GUESS ]]; then
      TRIES=$(($TRIES + 1))
      echo -e "\nIt's higher than that, guess again:"
    
    # if smaller
    else
      TRIES=$(($TRIES + 1))
      echo -e "\nIt's lower than that, guess again:"
    fi
  done
