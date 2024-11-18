#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo -e "\n~~~~ MY SALON ~~~~\n"
  if [[ $1 ]]
  then
    echo "$1"
  else
    SERVICES_MENU
  fi
}

SERVICES_MENU() {
  SERVICES_SELECT=$($PSQL "SELECT service_id, name FROM services" )
  if [[ -z $SERVICES_SELECT ]]
  then
    MAIN_MENU 'Sorry, no services available'
  else
    echo "Welcome, how can we help you?"
    echo "$SERVICES_SELECT" | while read SERVICE_ID BAR NAME
    do          
      echo "$SERVICE_ID) $NAME" 
    done
  fi
} 

MAIN_MENU
