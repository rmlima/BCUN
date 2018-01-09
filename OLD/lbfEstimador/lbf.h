/* 
 * File:   bloom.h
 * Author: rml
 *
 * Created on 24 de Março de 2015, 18:26
 */

#ifndef BLOOM_H
#define	BLOOM_H
#define M 1024 //LBF size in cell number
#define B 10
#define K 4 //LBF hash functions
void showLBF(float bloom[M])
{
int i;
printf("################## LBF Data ######################\n");
printf("bloom:\n");
for (i=0 ; i<M; i++)
        {
        printf("%.2f ",bloom[i]);
        if (!(i % 10)) { printf("\n");}
        }
printf("\n");
}



void insLBF(int elem, float confidence, float bloom[M])
{
int j,idx1,idx2,c,g;
unsigned char key[KEYSIZE];

md5(elem,key);
//mostra_md5(elem,key);
//printf("ResourceID: %d ", elem);
for (j=0 ; j<K*2; j+=2) {
    idx2=0;
    idx1=256*key[j]+key[j+1];
    //printf("Pos: %d \n", idx1);
    for (c = B-1; c >= 0; c--) {
        g = idx1 >> c;
        if (g & 1) idx2+=pow(2,c);
    }
    //printf("PosNew: %d \n", idx2);
    bloom[idx2]=max(confidence,bloom[idx2]);
   }
//printf("\n");
}


void mergeLBF(float bloom1[M], float bloom2[M], float *forward, float att)
{
int j;

for (j=0 ; j<M; j++)
   {
   forward[j]=max(bloom1[j],bloom2[j]*att);
   }
}

float searchLBF(int elem,float bloom[M])
{
int j,idx1,idx2,c,g;
float result;
unsigned char key[KEYSIZE];

md5(elem,key);
result=1;

for (j=0 ; j<K*2; j+=2) {
    idx2=0;
    idx1=256*key[j]+key[j+1];
    //printf("Pos: %d \n", idx1);
    for (c = B-1; c >= 0; c--) {
        g = idx1 >> c;
        if (g & 1) idx2+=pow(2,c);
    }
    //printf("PosNew: %d \n", idx2);
    result=min(result,bloom[idx2]);
   }
return (result);
}

//Distance estimator in HOPs for resource elem location.
int hopsLBF(int elem,float bloom[M], float att)
{
int j,idx1,idx2,c,g,h;
float confidence;
unsigned char key[KEYSIZE];

md5(elem,key);
confidence=1;

for (j=0 ; j<K*2; j+=2) {
    idx2=0;
    idx1=256*key[j]+key[j+1];
    //printf("Pos: %d \n", idx1);
    for (c = B-1; c >= 0; c--) {
        g = idx1 >> c;
        if (g & 1) idx2+=pow(2,c);
    }
    //printf("PosNew: %d \n", idx2);
    confidence=min(confidence,bloom[idx2]);
   }

if (confidence==0) {
    h=-1; }
else h=(int)round(log(confidence)/log(att));

return (h);
}


#endif	/* BLOOM_H */

