/* 
 * File:   hash.h
 * Author: rml
 *
 * Created on 24 de Março de 2015, 12:59
 */

#ifndef HASH_H
#define	HASH_H

#ifdef	__cplusplus
extern "C" {
#endif




#ifdef	__cplusplus
}
#endif

#define KEYSIZE 256
#include <mhash.h>

float max(float i, float j) {
        return (i > j) ? i : j;
}

float min(float i, float j) {
        return (i < j) ? i : j;
}

int md5(char *recurso, unsigned char hash[KEYSIZE])
{
 MHASH td;

 td = mhash_init(MHASH_MD5);
 if (td == MHASH_FAILED) return -1; else
 {
  mhash(td,recurso,sizeof(recurso));
  mhash_deinit(td, hash);
  return 0;
 }
}



int mostra_md5(char *recurso)
{
 int i;
 unsigned char hash[KEYSIZE];
 
 md5(recurso,hash);
 
 printf("Dados: %s",recurso);
 printf("\t");
 printf("Hash:");
 for (i = 0; i < KEYSIZE; i++) {
        printf("%.2x", hash[i]);
        }
 printf("\n");
 
 return 0;
 }


#endif	/* HASH_H */

