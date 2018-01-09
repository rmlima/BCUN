/* 
 * File:   main.c
 * Author: rml
 *
 * Created on 9 de Abril de 2015, 10:19
 */

#include <stdio.h>
#include <stdlib.h>
#include <mhash.h>
#include <string.h>
#include "hash.h"
#define FILTER_SIZE 5

#define NUM_HASHES 4
#define CONF_BITS 3 // MAX HOPs 7
#define BITS_HASH 8

// Pode indexar 2^BITS_HASH posições = 256, logo size=256*3/8=96
#define FILTER_SIZE_BYTES 96
#define KEYSIZE 16 //Hash key size
/*
 * 
 */

const char* byte_to_binary( unsigned char x )
{
    static char b[sizeof(unsigned char)*8+1] = {0};
    int y;
    long long z;
    for (z=1LL<<sizeof(unsigned char)*8-1,y=0; z>0; z>>=1,y++)
    {
        b[y] = ( ((x & z) == z) ? '1' : '0');
    }

    b[y] = 0;

    return b;
}

showLBF(unsigned char lbf[])
{
    int i,j;
    static char s[sizeof(unsigned char)*8+1];
    char data[8*FILTER_SIZE_BYTES];
    
    data[0]='\0';
    printf("Mostra Filtro LBF:\n");
    for (i = 0; i < FILTER_SIZE_BYTES; i++) {
        strcat(data,byte_to_binary(lbf[i]));
            //printf("%s ",byte_to_binary(lbf[i]));
        }
    for (i = 0; i < FILTER_SIZE_BYTES*8; i+=CONF_BITS)
        {
        for (j = 0; j < CONF_BITS; j++)
            printf("%c",data[i+j]);
        printf(" ");
        }
    
    
    printf("\n");
                
}

insLBF(int elem, unsigned char lbf[], int hop){
    unsigned char chave[KEYSIZE];
    int i;
    
    md5(elem,chave);
    for (i = 0; i < NUM_HASHES; i++)
        lbf[((chave[i]*CONF_BITS) >> 3)] |= (hop & 7);
        //lbf[chave[i] >> 3] |=1 << (chave[i] & 7);
        //lbf[chave[i] >> 3] |=1;
}

int getLBF(int elem, unsigned char lbf[]){
    unsigned char chave[KEYSIZE];
    int i;
    
    md5(elem,chave);
    for (i = 0; i < NUM_HASHES; i++)
        if (!(lbf[chave[i] >> 3] & (1 <<(chave[i] & 7))))
        //if (!(lbf[chave[i] >> 3] & (1 <<chave[i])))
            return 0;
    return 1;
}

int main(int argc, char** argv) {
unsigned char chave[KEYSIZE];
unsigned char lbf[FILTER_SIZE_BYTES];
int i;
        
for (i = 0; i < FILTER_SIZE_BYTES; i++)
    lbf[i] = 0;

showLBF(lbf);
insLBF(1,lbf,3);
showLBF(lbf);
/*
for (i = 0; i < FILTER_SIZE_BYTES; i++)
    lbf[i] = 0;
insLBF(2,lbf);
showLBF(lbf);
insLBF(1,lbf);
insLBF(2,lbf);
showLBF(lbf);

if (getLBF(1,lbf)) printf("O valor pode estar no filtro");
    else printf("O valor NÃO está no filtro");
*/
return (EXIT_SUCCESS);
}
