#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

echo "Enter your username:"
read USERNAME

USERNAME_RESULT=$($PSQL "SELECT  FROM games WHERE username='$USERNAME'")

if [[ $USERNAME_RESULT ]]
then
    echo "Welcome back, $USERNAME! You have played <games_played> games, and your best game took <best_game> guesses."
else 
    echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

echo "Guess the secret number between 1 and 1000:"
read GUESS
