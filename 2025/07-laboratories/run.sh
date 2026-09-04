#!/bin/sh
# FILE=example.txt
FILE=input.txt

g++ 07-lab.cpp -Wall -Werror -Wextra -o 07 && ./07 $FILE
