#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TEAMS=()

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ ! $YEAR =~ year ]]
  then
    if [[ ! $TEAMS[@] =~ $WINNER ]]
    then
        INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        echo "Insert $WINNER into teams result:"
        echo $INSERT_RESULT
        TEAMS+=$WINNER
    fi

    if [[ ! $TEAMS[@] =~ $OPPONENT ]]
    then
        INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        echo "Insert $OPPONENT into teams result:"
        echo $INSERT_RESULT
        TEAMS+=$OPPONENT
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo "Insert Result for $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
    echo "$INSERT_RESULT"
  fi
done
