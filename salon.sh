#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo -e "\n~~~~ MY SALON ~~~~\n"
  SERVICES_SELECT=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id" )
  if [[ -z $SERVICES_SELECT ]]
  then
    return 'no services available'
  else
    echo "Welcome, how can we help you?"
    echo "$SERVICES_SELECT" | while read SERVICE_ID BAR NAME
    do          
      echo "$SERVICE_ID) $NAME" 
    done
  fi
}

MAIN_MENU
