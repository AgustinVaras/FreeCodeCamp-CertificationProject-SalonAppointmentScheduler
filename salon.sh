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

EXIT_MENU() {
  echo -e "\nThank you for coming"
  exit
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
    echo "---------"
    echo "0) Exit"
    read SERVICE_ID_TO_SCHEDULE

    #Exit
    if [[ $SERVICE_ID_TO_SCHEDULE == 0 ]]
    then
      EXIT_MENU
    fi
    if [[ ! $SERVICE_ID_TO_SCHEDULE =~ ^[0-9]+$ ]]
    then
      MAIN_MENU 'That is not a valid service number'
    else
      #Read phone number
      echo -e "\nPlease input your phone number"
      read PHONE_NUMBER

      #Get customer ID and Name
      echo "$($PSQL "SELECT customer_id, name FROM customers WHERE phone = '$PHONE_NUMBER'" )" | read CUSTOMER_ID BAR NUMBER 

      #If not found
      if [[ -z $CUSTOMER_ID ]]
      then
        echo -e "\nI couldn't find that phone number, what's your name?"
      fi
    fi
  fi
} 

MAIN_MENU
