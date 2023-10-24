#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~ Welcome to Aura and Rousy's Wonderful Salon! ~~~~\n"

MAIN_MENU() {
    if  [[ $1 ]]
    then 
      echo "$1"
    else
      echo "How may we help you?"
    fi  

    echo -e "1) Cut\n2) Color\n3) Perm\n4) Style\n5) Trim\n6) Exit"
    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in
      1) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      2) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      3) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      4) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      5) SCHEDULE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
      6) echo "Thanks for stopping in!" ;;
      *) MAIN_MENU "Please pick a valid service." ;;
    esac  
}

SCHEDULE_APPOINTMENT() {
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $1")
    FILTERED_SERVICE_NAME=$(echo $SERVICE_NAME | sed 's/^ +//')
    echo -e "Great! What's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME
      FILTERED_CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed 's/^ +//')
      INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$FILTERED_CUSTOMER_NAME')")
      echo -e "\nWhat time would you like to come in for your $FILTERED_SERVICE_NAME, $FILTERED_CUSTOMER_NAME?"
      read SERVICE_TIME
    else   
      FILTERED_CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed 's/^ +//')
      echo -e "\nHello $FILTERED_CUSTOMER_NAME, what time would you like to come in for your $FILTERED_SERVICE_NAME?"
      read SERVICE_TIME
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$1,'$SERVICE_TIME')")
    echo I have put you down for a $FILTERED_SERVICE_NAME at $SERVICE_TIME, $FILTERED_CUSTOMER_NAME.  
}

MAIN_MENU
