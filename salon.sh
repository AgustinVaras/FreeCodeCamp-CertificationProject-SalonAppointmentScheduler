#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() { 
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\n~~~~ MY SALON ~~~~\n"
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
    #Exit Program
    if [[ $SERVICE_ID_TO_SCHEDULE == 0 ]]
    then
      EXIT
    fi
    if [[ ! $SERVICE_ID_TO_SCHEDULE =~ ^[0-9]+$ ]]
    then
      MAIN_MENU 'That is not a valid service number'
    else
      #Validate existing service      
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_TO_SCHEDULE " | sed -E 's/^ *| *$//g' )

      if [[ -z $SERVICE_NAME ]]
      then
        #if not exist
        MAIN_MENU "That's not a valid service number"
      else
        #Read phone number
        echo -e "\nPlease input your phone number"
        read PHONE_NUMBER
        #Get customer ID
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$PHONE_NUMBER' " )

        #If not found
        if [[ -z $CUSTOMER_ID ]]
        then
          echo -e "\nI couldn't find that phone number, what's your name?"
          read CUSTOMER_NAME
          #Insert new customer
          NEW_CUSTOMER $CUSTOMER_NAME $PHONE_NUMBER      

          #Get new customer ID
          CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$PHONE_NUMBER' " )    
        else
          #Get customer name
          CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID " | sed -E 's/^ *| *$//g' ) 
        fi

        #Read time
        echo -e "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME"
        read TIME


      fi

    fi
  fi
}



NEW_CUSTOMER() { #Inserts a new customer to the DB
  if [[ -z $1 || -z $2 ]]
  then
    echo -e "\nError, missing argument"
    return
  else
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$1', '$2')" )
    # echo "$1, $2"
  fi
}
 

EXIT() { #Función de salida del programa
  echo -e "\nThank you for coming"
  exit
}

#Ejecución
MAIN_MENU
