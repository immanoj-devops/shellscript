#!/bin/bash


USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
    echo -e "\e[1;32m Execute the script with root privilege \e[0m"
    exit 1
fi

Print() {
  echo -e "[\e[1;34mINFO\e[0m]----------< \e[1m $1 \e[0m>-----------------"
  echo -e "[\e[1;34mINFO\e[0m]\e[1m $2 \e[0m"
  echo -e "[\e[1;34mINFO\e[0m]-------------------------------------------------------------\n"

}

stat() {
  echo -e "\n[\e[1;34mINFO\e[0m]-------------------------------------------------------------"
if [ $1 -eq 0 ]; then
    echo -e "[\e[1;34mINFO\e[0m] \e[1;32mSUCCESS \e[0m"
else
    echo -e "[\e[1;34mINFO\e[0m] \e[1;31m EXIT STATUS - $1 :: FAILURE \e[0m"
    exit 4
fi
  echo -e "[\e[1;34mINFO\e[0m]-------------------------------------------------------------\n"
}