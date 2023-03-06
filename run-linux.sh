#!/bin/bash
# BIL 395 - Programming Languages - HW 1
# METIN EREN DURUCAN    201101038
# ONUR ÖZCAN            211101050

# LINUX VERSION
# RUN THE PROGRAM
# $ bash run.sh

# input.txt is the input file for the program.
# Please enter commands in the input.txt file.

# CLEAN
rm lex.yy.c
rm peakasso
rm peakasso.tab.c
rm peakasso.tab.h

# WAIT 1 SECOND
sleep 1

# LEX ANALYZER
flex peakasso.l
# YACC PARSER
bison -d peakasso.y
# COMPILER
gcc lex.yy.c peakasso.tab.c -o peakasso
# RUN (./peakasso < input.txt)
./peakasso