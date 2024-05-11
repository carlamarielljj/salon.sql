#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~ Salon Appointment Scheduler ~~~~\n"


 
  if [[ $1 ]]
  then
    echo-e "\n$1"
  fi

echo "Let's book your salon appointment!"

# display numbered list of services as service_id
SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

echo -e "\nHere are the available services:"
echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
# get service_id
echo -e "\nWhich service would you like to book?"
read SERVICE_ID_SELECTED

  # if it doesn't exist
  while [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]+$ ]] 
  do
    
   echo -e "\nThat was not a valid selection. Please choose a service from the list:"   
   echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
   do
    echo "$SERVICE_ID) $NAME"
   done
   echo -e "\nWhich service would you like to book?"
   read SERVICE_ID_SELECTED
  done
   
  
    
  # get customer_phone
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # if customer doesn't exist
    if [[ -z $CUSTOMER_NAME ]]
    then 
      # get new customer info
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME
    
      # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi

    # get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # get service_time
    echo -e "\nWhat time would you like to come in?"
    read SERVICE_TIME
  
    # insert appointment
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")

    # get appointment info
    SERVICE_BOOKED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    SERVICE_BOOKED_2=$(echo $SERVICE_BOOKED | sed 's/ |/"/')
    # confirm appointment
    echo "I have put you down for a $SERVICE_BOOKED_2 at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
  

  
  


