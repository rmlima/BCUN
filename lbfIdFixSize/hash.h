/* 
 * File:   hash.h
 * Author: rml
 *
 * Created on 24 de Março de 2015, 12:59
 */

#ifndef HASH_H
#define	HASH_H

#define KEYSIZE 16 //Hash key size

double max(double i, double j) {
        return (i > j) ? i : j;
}

double min(double i, double j) {
        return (i < j) ? i : j;
}

int md5(long long resourceID, unsigned char hash[KEYSIZE])
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

int mostra_md5(long long resourceID, unsigned char chave[KEYSIZE])
{
 int i;
 
 printf("ResourceID: %lld",resourceID);
 printf("\t");
 printf("Hash:");
 for (i = 0; i < KEYSIZE; i++) {
        printf("%.2x", chave[i]);
        }
 printf("\n");
 
 return 0;
 }

#endif	/* HASH_H */

