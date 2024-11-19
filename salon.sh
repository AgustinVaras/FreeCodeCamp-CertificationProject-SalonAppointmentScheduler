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
    read SERVICE_ID_TO_SCHEDULE
    if [[ ! $SERVICE_ID_TO_SCHEDULE =~ ^[0-9]+$ ]]
    then
      MAIN_MENU 'That is not a valid service number'
    else
      #Read phone number
      echo -e "\nPlease input your phone number"
      read PHONE_NUMBER
      #If not found
    fi
  fi
} 

MAIN_MENU
