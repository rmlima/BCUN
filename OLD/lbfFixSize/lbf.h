/* 
 * File:   bloom.h
 * Author: rml
 *
 * Created on 24 de Março de 2015, 18:26
 */
#include "const.h"
#ifndef BLOOM_H
#define	BLOOM_H

float dis2value(int dis, int conf_bits )
{ 
    return (float)dis/((1<<conf_bits)-1); 
}

unsigned short int value2dis(float confidence, int conf_bits)
{
    float inc,value;
    unsigned short int i=0;
    
    if (confidence==0) return 0;
    if (confidence==1) return (1<<conf_bits)-1;

    value=0;
    //printf("Confidence=%f\n",confidence);
    //printf("i=%d\t value=%f\n",i,value);
    
    inc=(float)1/((1<<conf_bits)-1);
    while (confidence>value)
    {
        value+=inc;
        i++;
    	//printf("i=%d\t value=%f\n",i,value);
    }
    return i-1;
}

int forward(int hop, float att, int conf_bits)
{
    int i,dis;
    float tmp;
    
    dis=(int)(1<<conf_bits)-1; //All bits to one
    
    for (i=0;i<hop;i++)
    {
        tmp=dis2value(dis,conf_bits);
        tmp*=att;
        dis=value2dis(tmp,conf_bits);
    }
    return dis;
}

int hopdiscovery(int dis, int conf_bits, float att )
{ 
    if (dis==0) return 0;
    
    int hop=0;
    int dis2;
    float tmp;
    
    dis2=(int)(1<<conf_bits)-1; //All bits to one
    while(dis!=dis2)
    {
        tmp=dis2value(dis2,conf_bits);
        tmp*=att;
        dis2=value2dis(tmp,conf_bits);
        hop++;
    }
    //printf("LBF=%d -> hop=%d ; att=%f\n",dis,hop,att);
    return hop;
}


void showLBF(short unsigned int lbf[MAXSIZE],int lbfsize)
{
int i;
printf("################## LBF Data ######################\n");
printf("bloom:\n");
for (i=0 ; i<lbfsize; i++)
        {
        printf("%d ",lbf[i]);
        if (!(i % 10)) { printf("\n");}
        }
printf("\n");
}

void insLBF(int elem, int hop, short unsigned int lbf[MAXSIZE], int num_hash, int hash_bits, int conf_bits, float att)
{
int j,idx1,idx2,c,g;
unsigned char key[KEYSIZE];

md5(elem,key);
//mostra_md5(elem,key);
//printf("ResourceID: %d ", elem);
for (j=0 ; j<num_hash*2; j+=2) {
    idx2=0;
    idx1=256*key[j]+key[j+1];
    //printf("Pos: %d \n", idx1);
    for (c = hash_bits-1; c >= 0; c--) {
        g = idx1 >> c;
        if (g & 1) idx2+=pow(2,c);
    }
    //printf("PosNew: %d Forward %d \n", idx2,forward(hop, att, conf_bits));
    lbf[idx2]=max(forward(hop, att, conf_bits),lbf[idx2]);
   }
//printf("\n");
}

unsigned short int searchLBF(int elem,short unsigned int lbf[MAXSIZE], int num_hash, int hash_bits, int conf_bits)
{
int j,idx1,idx2,c,g;
unsigned short int result;
unsigned char key[KEYSIZE];

md5(elem,key);
result=(int)(1<<conf_bits)-1;

for (j=0 ; j<num_hash*2; j+=2) {
    idx2=0;
    idx1=256*key[j]+key[j+1];
    //printf("Pos: %d \n", idx1);
    for (c = hash_bits-1; c >= 0; c--) {
        g = idx1 >> c;
        if (g & 1) idx2+=pow(2,c);
    }
    //printf("PosNew: %d \n", idx2);
    result=min(result,lbf[idx2]);
   }
return (result);
}

//Distance estimator in HOPs for resource elem location.
int hopsLBF(int elem,short unsigned int lbf[MAXSIZE], float att, int num_hash, int hash_bits, int conf_bits)
{
short unsigned int dis;

dis=searchLBF(elem,lbf,num_hash,hash_bits,conf_bits);
return hopdiscovery(dis, conf_bits, att);
}
#endif	/* BLOOM_H */