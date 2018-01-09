/* 
 * File:   hash.h
 * Author: rml
 *
 * Created on 24 de Março de 2015, 12:59
 */

#ifndef HASH_H
#define	HASH_H

#define KEYSIZE 16 //Hash key size




float max(float i, float j) {
        return (i > j) ? i : j;
}

float min(float i, float j) {
        return (i < j) ? i : j;
}

int md5(int resourceID, unsigned char hash[KEYSIZE])
{

 MHASH td;

 td = mhash_init(MHASH_MD5);
 if (td == MHASH_FAILED) return -1; else
 {
  mhash(td,&resourceID,sizeof(resourceID));
  mhash_deinit(td, hash);
  return 0;
 }
}

int mostra_md5(int resourceID, unsigned char chave[KEYSIZE])
{
 int i;
 
 printf("ResourceID: %d",resourceID);
 printf("\t");
 printf("Hash:");
 for (i = 0; i < KEYSIZE; i++) {
        printf("%.2x", chave[i]);
        }
 printf("\n");
 
 return 0;
 }

#endif	/* HASH_H */

