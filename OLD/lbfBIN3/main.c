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
#define MAXSIZE 1024
#define KEYSIZE 16 //Hash key size
/*
 * 
 */


showLBF(unsigned char lbf[], int lbfsize, int conf_bits)
{
    int i,j;

    printf("Mostra Filtro LBF:\n");
    /*
    for (i = 0; i < FILTER_SIZE_BYTES; i++) {
        strcat(data,byte_to_binary(lbf[i]));
            //printf("%s ",byte_to_binary(lbf[i]));
        }
     */
    for (i = 0; i < lbfsize; i+=conf_bits)
        {
        for (j = 0; j < conf_bits; j++)
            printf("%c",lbf[i+j]);
        printf(" ");
        }
    printf("\n");
                
}

insLBF(int elem, unsigned char lbf[], int hop, int num_hash, int conf_bits){
    unsigned char chave[KEYSIZE];
    int i,j,pos,k;
    
    md5(elem,chave);
    
    for (i = 0; i < num_hash; i++) {
        pos = (int) chave[i] * conf_bits;
        //printf("POS=%d\n",pos);
        for (j=0; j<conf_bits; j++) {
            k=hop >> (conf_bits-j-1);
            if (k & 1)
                lbf[pos+j]='1';
            else
                lbf[pos+j]='0';
        }
    }
}
/*
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
*/
int main(int argc, char** argv) {
unsigned char chave[KEYSIZE];
unsigned char lbf[MAXSIZE];
int i;
int num_hash=5;
int conf_bits=4; // MAX HOPs 7
int hash_bits=8;
int lbfsize;

lbfsize=(1<<hash_bits)*conf_bits;

printf("LBFsize=%d\n",lbfsize);


// 2^BITS_HASH posições = 256, logo size=256*3=96

        
for (i = 0; i < lbfsize; i++)
    lbf[i] = '0';
lbf[lbfsize]='\0';

showLBF(lbf,lbfsize,conf_bits);

insLBF(1,lbf,3,num_hash,conf_bits);
showLBF(lbf,lbfsize,conf_bits);

for (i = 0; i < lbfsize; i++)
    lbf[i] = '0';
lbf[lbfsize]='\0';

insLBF(2,lbf,4,num_hash,conf_bits);
showLBF(lbf,lbfsize,conf_bits);
insLBF(1,lbf,3,num_hash,conf_bits);
insLBF(2,lbf,4,num_hash,conf_bits);
showLBF(lbf,lbfsize,conf_bits);
/*
if (getLBF(1,lbf)) printf("O valor pode estar no filtro");
    else printf("O valor NÃO está no filtro");
*/
return (EXIT_SUCCESS);
}
