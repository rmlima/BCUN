/* 
 * File:   main.c
 * Author: rml
 *
 * Created on 9 de Abril de 2015, 10:19
 */

#include <stdio.h>
#include <stdlib.h>
#include <mhash.h>
#include "hash.h"
#define FILTER_SIZE 5

#define NUM_HASHES 4
#define CONF_BITS 1 // MAX HOPs 3
#define BITS_HASH 8


#define FILTER_SIZE_BYTES 32
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
    int i;
   printf("Mostra Filtro LBF:\n");
    for (i = 0; i < FILTER_SIZE_BYTES; i++) {
            printf("%s ",byte_to_binary(lbf[i]));
        }
   printf("\n");
                
}

insLBF(int elem, unsigned char lbf[]){
    unsigned char chave[KEYSIZE];
    int i;
    
    md5(elem,chave);
    for (i = 0; i < NUM_HASHES; i++)
        lbf[chave[i] >> 3] |=1 << (chave[i] & 7);
        //lbf[chave[i] >> 3] |=1 << chave[i];
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
insLBF(1,lbf);
showLBF(lbf);
for (i = 0; i < FILTER_SIZE_BYTES; i++)
    lbf[i] = 0;
insLBF(2,lbf);
showLBF(lbf);
insLBF(1,lbf);
insLBF(2,lbf);
showLBF(lbf);

if (getLBF(1,lbf)) printf("O valor pode estar no filtro");
    else printf("O valor NÃO está no filtro");
return (EXIT_SUCCESS);
}
