Open the directory 2022CSB1168 and use the following commands to run the program :
flex cucu.l
bison -d cucu.y
gcc lex.yy.c cucu.tab.c -ll
./a.out

To change the input file go to the main function written in cucu.y and change the file being assigned to yyin.