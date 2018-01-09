/* 
 * File:   main.c
 * Author: rml
 *
 * Created on 24 de Março de 2015, 12:41
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash.h"
/*
 * 
 */
int main(int argc, char** argv) {
int i;
unsigned char buffer;
char word1[256], word2[256];
char a,c;

printf("Este exemplo mostra o funcionamento do HASH!\n");

printf("Uma string com um único caracter: ""1""\n");
mostra_md5("1");
printf("Exactamente a mesma string anterior: ""1""\n");
mostra_md5("1");
printf("\n");

printf("!Até aqui tudo bem!\n");
printf("\n");

printf("Uma string depois de usar o strcpy com um único caracter: ""1""\n");
strcpy (word1,"1");
mostra_md5(word1);
printf("\n");

printf("Um único caracter definido num char: '1'\n");
c='1';
mostra_md5(&c);
printf("\n");

printf("Um único caracter definido num char: '1'\n");
a='1';
mostra_md5(&a);
printf("\n");


printf("Introduza um character\n");
scanf("%c", &c);
mostra_md5(&c);


printf("Introduza uma string\n");
scanf("%s" ,word2);
mostra_md5(word2);
printf("\n");


return (EXIT_SUCCESS);
}

