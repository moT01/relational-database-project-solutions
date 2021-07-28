#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~ Number Guess ~~\n"

# get username as input
printf "Enter your username: "
read USERNAME

# get username from database
USERNAME_RESULT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")

# if doesn't exist
if [[ -z $USERNAME_RESULT ]]
then
  echo -e "Welcome, $USERNAME! It looks like this is your first time here.\n"

  # create new user
  INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")

# user exists
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
  FEWEST_GUESSES=$($PSQL "SELECT fewest_guesses FROM users WHERE username='$USERNAME'")

  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games,\nand your best game took $FEWEST_GUESSES guesses.\n"
fi

# Start Game
NUMBER=$((RANDOM % 1000 + 1))
GUESSES=0

printf "Guess the secret number between 1 and 1000: "

while [[ $GUESS != $NUMBER ]]
do
  read GUESS
  (( GUESSES = $GUESSES + 1 ))

  if [[ ! $GUESS =~ ^-?[0-9]+$ ]]
  then
    printf "That is not an integer, guess again: "
  elif [[ $GUESS -lt $NUMBER ]]
  then
    printf "It's higher than that, guess again: "
  elif [[ $GUESS -gt $NUMBER ]]
  then
    printf "It's lower than that, guess again: "
  fi
done

if [[ $GUESS -eq $NUMBER ]]
then
  # Add one to games played
  UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = games_played + 1  WHERE username='$USERNAME'")

  # If best game
  if [[ -z $FEWEST_GUESSES || $GUESSES -lt $FEWEST_GUESSES ]]
  then
    UPDATE_FEWEST_GUESSES=$($PSQL "UPDATE users SET fewest_guesses = $GUESSES WHERE username='$USERNAME'")
  fi

  echo "You guessed it in $GUESSES tries. The secret number was $NUMBER. Nice job!"
fi