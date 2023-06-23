#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USERNAME_RESULT=$($PSQL "SELECT games_played, best_game_id, guess FROM users LEFT JOIN games ON users.best_game_id=games.game_id;")


if [[ $USERNAME_RESULT ]]
then
    echo $USERNAME_RESULT | while IFS="|" read GAMES_PLAYED BAR BEST_GAME_ID BAR GUESSES 
    do 
        echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $GUESSES guesses."
    done
    UPDATE_GAMES_PLAYED=$($PSQL "")
else 
    echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

echo "Guess the secret number between 1 and 1000:"
read GUESS
